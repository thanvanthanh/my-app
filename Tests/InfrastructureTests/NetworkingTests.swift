import Foundation
import Testing
@testable import my_app

struct NetworkingTests {
    @Test
    func buildsEndpointURLWithoutDroppingHost() throws {
        let url = try BaseAPI<APIRouter>.buildURL(
            baseURL: "https://api.github.com/",
            request: .requestPath(path: "/search/users")
        )

        #expect(url.absoluteString == "https://api.github.com/search/users")
    }

    @Test
    func rejectsInsecureOrHostlessBaseURL() {
        #expect(throws: APIError.self) {
            try BaseAPI<APIRouter>.buildURL(
                baseURL: "https://",
                request: .requestPath(path: "/search/users")
            )
        }
        #expect(throws: APIError.self) {
            try BaseAPI<APIRouter>.buildURL(
                baseURL: "http://api.github.com",
                request: .requestPath(path: "/search/users")
            )
        }
    }

    @Test
    func concurrentRefreshCallsShareOneOperation() async {
        let coordinator = RefreshTokenCoordinator()
        let counter = InvocationCounter()
        let operation: @Sendable () async -> Bool = {
            await counter.increment()
            try? await Task.sleep(for: .milliseconds(50))
            return true
        }

        async let first = coordinator.refresh(using: operation)
        async let second = coordinator.refresh(using: operation)
        async let third = coordinator.refresh(using: operation)
        let results = await [first, second, third]

        #expect(results == [true, true, true])
        #expect(await counter.value == 1)
    }
}

private actor InvocationCounter {
    private(set) var value = 0

    func increment() {
        value += 1
    }
}
