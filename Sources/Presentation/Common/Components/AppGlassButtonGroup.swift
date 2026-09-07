import SwiftUI

struct AppGlassButtonGroup<Content: View>: View {
    let spacing: CGFloat
    let content: Content

    init(
        spacing: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                VStack(spacing: spacing) {
                    content
                }
            }
        } else {
            VStack(spacing: spacing) {
                content
            }
        }
    }
}
