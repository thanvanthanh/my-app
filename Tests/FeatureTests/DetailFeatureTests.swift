//
//  DetailFeatureTests.swift
//  my-appTests
//
//  Created by Thanh Than on 07/09/2026.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import my_app

@MainActor
struct DetailFeatureTests {

    @Test
    func openProfileButtonTappedOpensURL() async {
        let profileURL = URL(string: "https://github.com/thanhthan")!
        let user = SearchModel(
            id: 1,
            avatarUrl: "https://avatar.com/1",
            htmlUrl: profileURL,
            login: "thanhthan"
        )

        await confirmation("URL opened successfully") { confirm in
            let store = TestStore(initialState: DetailState(user: user)) {
                DetailFeature()
            } withDependencies: {
                $0.openURL = .init { url in
                    #expect(url == profileURL)
                    confirm()
                    return true
                }
            }

            await store.send(.openProfileButtonTapped)
        }
    }
}
