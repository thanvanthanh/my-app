import SwiftUI

struct AppGlassButton: View {
    enum Prominence {
        case primary
        case secondary
    }

    let title: String
    let foregroundColor: Color
    let tintColor: Color
    let prominence: Prominence
    let minHeight: CGFloat
    let fontSize: CGFloat
    let isEnabled: Bool
    let action: () -> Void

    init(
        _ title: String,
        foregroundColor: Color = .primary,
        tintColor: Color = .accentColor,
        prominence: Prominence = .secondary,
        minHeight: CGFloat = 70,
        fontSize: CGFloat = 18,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.foregroundColor = foregroundColor
        self.tintColor = tintColor
        self.prominence = prominence
        self.minHeight = minHeight
        self.fontSize = fontSize
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                glassButton
            } else {
                legacyButton
            }
        }
        .disabled(!isEnabled)
        .overlay {
            if !isEnabled {
                Capsule()
                    .stroke(disabledBorderColor, lineWidth: 1)
            }
        }
    }

    @available(iOS 26.0, *)
    @ViewBuilder
    private var glassButton: some View {
        switch prominence {
        case .primary:
            buttonLabel
                .buttonStyle(.glassProminent)
                .tint(effectiveTintColor)
        case .secondary:
            buttonLabel
                .buttonStyle(.glass)
                .tint(effectiveTintColor)
        }
    }

    private var legacyButton: some View {
        buttonLabel
            .buttonStyle(.plain)
            .background(effectiveTintColor, in: Capsule())
    }

    private var buttonLabel: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundStyle(effectiveForegroundColor)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .contentShape(Capsule())
        }
    }

    private var effectiveTintColor: Color {
        isEnabled
            ? tintColor
            : Color(Asset.ColorsIOS.authDisabledButtonBackground.color)
    }

    private var effectiveForegroundColor: Color {
        isEnabled
            ? foregroundColor
            : Color(Asset.ColorsIOS.authDisabledButtonText.color)
    }

    private var disabledBorderColor: Color {
        Color(Asset.ColorsIOS.authDisabledButtonBorder.color)
    }
}

#Preview("App Glass Buttons") {
    VStack(spacing: 16) {
        AppGlassButton(
            "Primary action",
            foregroundColor: .white,
            tintColor: .purple,
            prominence: .primary,
            action: {}
        )

        AppGlassButton(
            "Secondary action",
            tintColor: .white,
            action: {}
        )
    }
    .padding()
    .background(Color.indigo.gradient)
}
