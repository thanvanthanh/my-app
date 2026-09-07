//
//  SearchView.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    @Bindable var store: StoreOf<SearchFeature>

    var body: some View {
        List {
            if store.isLoading && store.users.isEmpty {
                HStack {
                    Spacer()
                    ProgressView("Searching GitHub users...")
                        .padding(.vertical, 32)
                    Spacer()
                }
                .listRowSeparator(.hidden)
            } else if let errorMessage = store.errorMessage {
                SearchEmptyView(
                    iconName: "exclamationmark.triangle",
                    title: "Error",
                    message: errorMessage
                )
                .listRowSeparator(.hidden)
            } else if store.isListEmpty {
                SearchEmptyView(
                    iconName: "magnifyingglass",
                    title: "No Results",
                    message: "Could not find any users matching \"\(store.query)\"."
                )
                .listRowSeparator(.hidden)
            } else {
                ForEach(store.users) { user in
                    Button {
                        store.send(.userTapped(user))
                    } label: {
                        UserRowView(user: user)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Search")
        .searchable(
            text: $store.query.sending(\.queryChanged),
            prompt: "Search GitHub users"
        )
        .onSubmit(of: .search) {
            store.send(.searchSubmitted)
        }
        .refreshable {
            await store.send(.refreshTriggered).finish()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
