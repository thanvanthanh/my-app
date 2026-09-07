import ComposableArchitecture

@Reducer
struct WelcomeFeature {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {}

    enum Action: Equatable, Sendable {
        case signInTapped
        case signUpTapped
        case delegate(Delegate)

        enum Delegate: Equatable, Sendable {
            case showLogin
            case continueToApp
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .signInTapped:
                return .send(.delegate(.showLogin))
            case .signUpTapped:
                return .send(.delegate(.continueToApp))
            case .delegate:
                return .none
            }
        }
    }
}
