//
//  RootView.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Perception.Bindable var store: StoreOf<RootFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \RootAction.Cases.path)) {
            SearchView(store: store.scope(state: \.search, action: \.search))
        } destination: { pathStore in
            switch pathStore.case {
            case let .detail(detailStore):
                DetailView(store: detailStore)
            }
        }
    }
}
