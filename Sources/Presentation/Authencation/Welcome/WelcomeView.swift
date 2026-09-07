import ComposableArchitecture
import SwiftUI

struct WelcomeView: View {
    let store: StoreOf<WelcomeFeature>

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(spacing: 0) {
                welcomeCard
                    .padding(.top, 71)

                Spacer(minLength: 48)
                actionButtons
                Spacer(minLength: 24)

                Text(L10n.welcomeFooter)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(Asset.ColorsIOS.authSecondaryText.color))
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var welcomeCard: some View {
        AppGradientCard(cornerRadius: 36) {
            VStack(spacing: 0) {
                Image(Asset.AssetsIOS.appIcon.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .accessibilityHidden(true)

                Text(L10n.welcomeAppName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color(Asset.ColorsIOS.authPrimaryText.color))
                    .padding(.top, 25)

                Text(L10n.welcomeSubtitle)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(Asset.ColorsIOS.authSecondaryText.color))
                    .padding(.top, 14)
            }
            .frame(maxWidth: .infinity, minHeight: 420)
        }
    }

    private var actionButtons: some View {
        AppGlassButtonGroup(spacing: 12) {
            AppGlassButton(
                L10n.welcomeCreateAccountTitle,
                foregroundColor: .white,
                tintColor: Color(Asset.ColorsIOS.authAccent.color),
                prominence: .primary,
                minHeight: 54,
                fontSize: 17,
                action: { store.send(.signUpTapped) }
            )

            AppGlassButton(
                L10n.welcomeSignInTitle,
                foregroundColor: Color(Asset.ColorsIOS.authPrimaryText.color),
                tintColor: Color(Asset.ColorsIOS.authSurfaceTop.color),
                minHeight: 54,
                fontSize: 17,
                action: { store.send(.signInTapped) }
            )
        }
    }
}

#Preview("Light") {
    WelcomeView(store: Store(initialState: WelcomeFeature.State()) { WelcomeFeature() })
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    WelcomeView(store: Store(initialState: WelcomeFeature.State()) { WelcomeFeature() })
        .preferredColorScheme(.dark)
}
