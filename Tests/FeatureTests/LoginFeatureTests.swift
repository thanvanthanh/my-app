import ComposableArchitecture
import Testing
@testable import my_app

@MainActor
struct LoginFeatureTests {
    @Test
    func signInIsEnabledForValidCredentials() {
        let state = LoginFeature.State(
            email: "user@example.com",
            password: "123456"
        )

        #expect(state.isSignInEnabled)
    }

    @Test
    func signInIsDisabledForInvalidCredentials() {
        #expect(!LoginFeature.State(email: "invalid", password: "123456").isSignInEnabled)
        #expect(!LoginFeature.State(email: "user@example.com", password: "12345").isSignInEnabled)
    }

    @Test
    func invalidCredentialsDoNotSignIn() async {
        let store = TestStore(
            initialState: LoginFeature.State(email: "invalid", password: "123456")
        ) {
            LoginFeature()
        }

        await store.send(.signInTapped)
    }

    @Test
    func validCredentialsSignIn() async {
        let store = TestStore(
            initialState: LoginFeature.State(
                email: "user@example.com",
                password: "123456"
            )
        ) {
            LoginFeature()
        }

        await store.send(.signInTapped)
        await store.receive(.delegate(.signedIn))
    }
}
