import SwiftUI

struct AppGlassIconButton: View {
    let systemImage: String
    let diameter: CGFloat
    let iconSize: CGFloat
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            button.buttonStyle(.glass)
        } else {
            button
                .buttonStyle(.plain)
                .background(Color(Asset.ColorsIOS.authSurfaceTop.color), in: Circle())
                .overlay { Circle().stroke(Color(Asset.ColorsIOS.authBorderTop.color)) }
        }
    }

    private var button: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: .medium))
                .frame(width: diameter, height: diameter)
        }
        .buttonBorderShape(.circle)
        .clipShape(Circle())
        .contentShape(Circle())
        .tint(Color(Asset.ColorsIOS.authAccent.color))
        .accessibilityLabel(accessibilityLabel)
    }
}
