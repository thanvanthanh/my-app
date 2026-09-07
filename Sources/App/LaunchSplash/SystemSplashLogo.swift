//
//  SystemSplashLogo.swift
//  my-app
//
//  Created by Thanh Than on 7/9/26.
//

import SwiftUI

struct SystemSplashLogo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(
                                red: 0.28,
                                green: 0.56,
                                blue: 1.00
                            ),
                            Color(
                                red: 0.62,
                                green: 0.36,
                                blue: 1.00
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: "sparkles")
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(.white)
                .symbolRenderingMode(.hierarchical)
        }
        .frame(width: 96, height: 96)
    }
}
