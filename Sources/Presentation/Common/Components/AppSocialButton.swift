import SwiftUI

struct AppSocialButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(Asset.ColorsIOS.authAppleText.color))
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color(Asset.ColorsIOS.authAppleBackground.color), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}
