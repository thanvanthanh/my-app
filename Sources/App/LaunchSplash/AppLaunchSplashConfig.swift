//
//  AppLaunchSplashConfig.swift
//  my-app
//
//  Created by Thanh Than on 7/9/26.
//

import SwiftUI

struct AppLaunchSplashConfig {
    var backgroundColor = Color(Asset.ColorsIOS.launchBackground.color)
    
    var initialDelay: TimeInterval = 0.18
    var logoAppearDuration: TimeInterval = 0.42
    var holdDuration: TimeInterval = 0.35
    var punchDuration: TimeInterval = 0.72
    var expandedScale: CGFloat = 34
    
    static let `default` = AppLaunchSplashConfig()
}

// MARK: - View Extension

extension View {
    func appLaunchSplash<Logo: View>(
        config: AppLaunchSplashConfig = .default,
        @ViewBuilder logo: @escaping () -> Logo
    ) -> some View {
        modifier(
            AppLaunchSplashModifier(
                config: config,
                logo: logo
            )
        )
    }
}

// MARK: - Modifier

private struct AppLaunchSplashModifier<Logo: View>: ViewModifier {
    let config: AppLaunchSplashConfig
    let logo: () -> Logo
    
    @Environment(\.accessibilityReduceMotion)
    private var accessibilityReduceMotion
    @State private var isShowingSplash = true
    
    func body(content: Content) -> some View {
        ZStack {
            config.backgroundColor
                .ignoresSafeArea()
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityHidden(isShowingSplash)
                .background {
                    config.backgroundColor
                        .ignoresSafeArea()
                }
            
            if isShowingSplash {
                AppLaunchSplashView(
                    config: config,
                    reduceMotion: accessibilityReduceMotion,
                    logo: logo
                ) {
                    isShowingSplash = false
                }
                .transition(.identity)
                .zIndex(999)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            config.backgroundColor
                .ignoresSafeArea()
        }
    }
}

// MARK: - Splash View

private struct AppLaunchSplashView<Logo: View>: View {
    let config: AppLaunchSplashConfig
    let reduceMotion: Bool
    let logo: () -> Logo
    let onComplete: () -> Void
    
    @State private var didStart = false
    @State private var logoVisible = false
    @State private var logoScale: CGFloat = 0.78
    @State private var punchScale: CGFloat = 1
    @State private var isPunching = false
    @State private var overlayOpacity: Double = 1
    
    var body: some View {
        ZStack {
            splashMaskLayer
            
            if !isPunching {
                logo()
                    .scaleEffect(logoScale)
                    .opacity(logoVisible ? 1 : 0)
                    .shadow(
                        color: .black.opacity(0.22),
                        radius: 24,
                        x: 0,
                        y: 14
                    )
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
        .task {
            await startAnimationIfNeeded()
        }
    }
    
    private var splashMaskLayer: some View {
        Rectangle()
            .fill(config.backgroundColor)
            .overlay {
                if isPunching {
                    logo()
                        .scaleEffect(punchScale)
                        .blendMode(.destinationOut)
                }
            }
            .compositingGroup()
            .opacity(overlayOpacity)
            .ignoresSafeArea()
    }
    
    @MainActor
    private func startAnimationIfNeeded() async {
        guard !didStart else {
            return
        }
        didStart = true
        
        guard !reduceMotion else {
            onComplete()
            return
        }
        
        do {
            try await Task.sleep(for: .seconds(config.initialDelay))
            withAnimation(
                .spring(
                    response: config.logoAppearDuration,
                    dampingFraction: 0.72,
                    blendDuration: 0
                )
            ) {
                logoVisible = true
                logoScale = 1
            }
            
            try await Task.sleep(
                for: .seconds(config.logoAppearDuration + config.holdDuration)
            )
            withAnimation(.easeInOut(duration: 0.16)) {
                logoScale = 0.88
            }
            
            try await Task.sleep(for: .seconds(0.13))
            isPunching = true
            punchScale = 0.88
            
            withAnimation(.easeInOut(duration: config.punchDuration)) {
                punchScale = config.expandedScale
                overlayOpacity = 0
            }
            
            try await Task.sleep(for: .seconds(config.punchDuration))
            onComplete()
        } catch is CancellationError {
            return
        } catch {
            return
        }
    }
}
