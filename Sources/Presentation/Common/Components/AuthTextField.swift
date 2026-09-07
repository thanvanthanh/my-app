import SwiftUI

struct AuthTextField: View {
    let title: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var isSecure = false
    var keyboardType: UIKeyboardType = .default

    @State private var isTextVisible = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color(Asset.ColorsIOS.authSecondaryText.color))
                .padding(.leading, 2)

            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundStyle(Color(Asset.ColorsIOS.authFieldIcon.color))
                    .frame(width: 20)

                Group {
                    if isSecure && !isTextVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .textInputAutocapitalization(.never)
                            .keyboardType(keyboardType)
                    }
                }
                .focused($isFocused)
                .foregroundStyle(Color(Asset.ColorsIOS.authPrimaryText.color))

                if isSecure {
                    Button {
                        isTextVisible.toggle()
                        isFocused = true
                    } label: {
                        Image(systemName: isTextVisible ? "eye.slash" : "eye")
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Color(Asset.ColorsIOS.authFieldIcon.color))
                    .accessibilityLabel(
                        isTextVisible
                            ? L10n.loginHidePasswordAccessibility
                            : L10n.loginShowPasswordAccessibility
                    )
                }
            }
            .font(.system(size: 15))
            .padding(.horizontal, 13)
            .frame(height: 50)
            .background {
                LinearGradient(
                    colors: [Color(Asset.ColorsIOS.authFieldTop.color), Color(Asset.ColorsIOS.authFieldBottom.color)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 17)
                    .stroke(
                        LinearGradient(
                            colors: [Color(Asset.ColorsIOS.authFieldBorderTop.color), Color(Asset.ColorsIOS.authFieldBorderBottom.color)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 17))
        }
    }
}
