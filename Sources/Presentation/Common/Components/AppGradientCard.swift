import SwiftUI

struct AppGradientCard<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content

    init(cornerRadius: CGFloat = 32, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .background {
                LinearGradient(
                    colors: [
                        Color(Asset.ColorsIOS.authSurfaceTop.color),
                        Color(Asset.ColorsIOS.authSurfaceBottom.color)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(Asset.ColorsIOS.authBorderTop.color),
                                Color(Asset.ColorsIOS.authBorderMiddle.color),
                                Color(Asset.ColorsIOS.authBorderBottom.color)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
