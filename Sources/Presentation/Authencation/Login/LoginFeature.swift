import ComposableArchitecture
import Foundation

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        var email = ""
        var password = ""

        var isSignInEnabled: Bool {
            isEmailValid && password.count >= 6
        }

        private var isEmailValid: Bool {
            email.range(
                of: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#,
                options: [.regularExpression, .caseInsensitive]
            ) != nil
        }
    }

    enum Action: Equatable, Sendable {
        case emailChanged(String)
        case passwordChanged(String)
        case backTapped
        case forgotPasswordTapped
        case signInTapped
        case faceIDTapped
        case appleSignInTapped
        case signUpTapped
        case delegate(Delegate)

        enum Delegate: Equatable, Sendable {
            case dismiss
            case signedIn
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                return .none
            case let .passwordChanged(password):
                state.password = password
                return .none
            case .backTapped:
                return .send(.delegate(.dismiss))
            case .signInTapped where state.isSignInEnabled:
                return .send(.delegate(.signedIn))
            case .signInTapped:
                return .none
            case .faceIDTapped, .appleSignInTapped:
                return .send(.delegate(.signedIn))
            case .forgotPasswordTapped, .signUpTapped, .delegate:
                return .none
            }
        }
    }
}
