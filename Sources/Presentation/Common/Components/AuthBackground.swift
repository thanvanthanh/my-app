import SwiftUI

struct AuthBackground: View {
    var body: some View {
        ZStack {
            Color(Asset.ColorsIOS.authBackground.color)

            RadialGradient(
                colors: [Color(Asset.ColorsIOS.authTopGlow.color), .clear],
                center: UnitPoint(x: 0.8, y: 0.15),
                startRadius: 0,
                endRadius: 300
            )

            RadialGradient(
                colors: [Color(Asset.ColorsIOS.authBottomGlow.color), .clear],
                center: UnitPoint(x: 0.2, y: 0.8),
                startRadius: 0,
                endRadius: 280
            )
        }
        .ignoresSafeArea()
    }
}
