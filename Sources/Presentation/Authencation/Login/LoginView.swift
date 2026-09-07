import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: StoreOf<LoginFeature>

    var body: some View {
        @Bindable var store = store
        return content(
            email: $store.email.sending(\.emailChanged),
            password: $store.password.sending(\.passwordChanged),
            isSignInEnabled: store.isSignInEnabled
        )
    }

    private func content(
        email: Binding<String>,
        password: Binding<String>,
        isSignInEnabled: Bool
    ) -> some View {
        ZStack {
            AuthBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    AppGlassIconButton(
                        systemImage: "chevron.left",
                        diameter: 40,
                        iconSize: 20,
                        accessibilityLabel: L10n.loginBackAccessibility,
                        action: { store.send(.backTapped) }
                    )

                    titleSection
                    loginForm(
                        email: email,
                        password: password,
                        isSignInEnabled: isSignInEnabled
                    )
                    faceIDSection

                    AppSocialButton(
                        title: L10n.loginApple,
                        systemImage: "apple.logo",
                        action: { store.send(.appleSignInTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 45)

                    signUpPrompt
                }
                .padding(.horizontal, 24)
                .padding(.top, 5)
                .padding(.bottom, 10)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .dismissKeyboardOnTap()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(L10n.loginTitle)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color(Asset.ColorsIOS.authPrimaryText.color))

            Text(L10n.loginSubtitle)
                .font(.system(size: 15))
                .foregroundStyle(Color(Asset.ColorsIOS.authSecondaryText.color))
        }
        .padding(.top, 18)
        .padding(.leading, 2)
    }

    private func loginForm(
        email: Binding<String>,
        password: Binding<String>,
        isSignInEnabled: Bool
    ) -> some View {
        AppGradientCard {
            VStack(spacing: 18) {
                AuthTextField(
                    title: L10n.loginEmailLabel,
                    placeholder: L10n.loginEmailPlaceholder,
                    systemImage: "envelope",
                    text: email,
                    keyboardType: .emailAddress
                )

                AuthTextField(
                    title: L10n.loginPasswordLabel,
                    placeholder: L10n.loginPasswordPlaceholder,
                    systemImage: "lock",
                    text: password,
                    isSecure: true
                )

                Button(L10n.loginForgotPassword) {
                    store.send(.forgotPasswordTapped)
                }
                .font(.system(size: 13))
                .foregroundStyle(Color(Asset.ColorsIOS.authAccent.color))
                .frame(maxWidth: .infinity, alignment: .trailing)

                AppGlassButton(
                    L10n.loginSignIn,
                    foregroundColor: .white,
                    tintColor: Color(Asset.ColorsIOS.authAccent.color),
                    prominence: .primary,
                    minHeight: 52,
                    fontSize: 17,
                    isEnabled: isSignInEnabled,
                    action: { store.send(.signInTapped) }
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .frame(height: 325)
        }
        .padding(.top, 26)
    }

    private var faceIDSection: some View {
        VStack(spacing: 13) {
            AppGlassIconButton(
                systemImage: "faceid",
                diameter: 84,
                iconSize: 32,
                accessibilityLabel: L10n.loginFaceId,
                action: { store.send(.faceIDTapped) }
            )

            Text(L10n.loginFaceId)
                .font(.system(size: 13))
                .foregroundStyle(Color(Asset.ColorsIOS.authSecondaryText.color))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 32)
    }

    private var signUpPrompt: some View {
        HStack(spacing: 3) {
            Text(L10n.loginNoAccount)
                .foregroundStyle(Color(Asset.ColorsIOS.authSecondaryText.color))
            Button(L10n.loginSignUp) { store.send(.signUpTapped) }
                .fontWeight(.bold)
                .foregroundStyle(Color(Asset.ColorsIOS.authAccent.color))
        }
        .font(.system(size: 13))
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
    }

}

#Preview("Login Dark") {
    LoginView(store: Store(initialState: LoginFeature.State()) { LoginFeature() })
        .preferredColorScheme(.dark)
}

#Preview("Login Light") {
    LoginView(store: Store(initialState: LoginFeature.State()) { LoginFeature() })
        .preferredColorScheme(.light)
}
