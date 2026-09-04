//
//  DetailView.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    let store: StoreOf<DetailFeature>

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AsyncImage(url: URL(string: store.user.avatarUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.accentColor.opacity(0.3), lineWidth: 3))
                            .shadow(radius: 6)
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 120, height: 120)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.top, 32)

                VStack(spacing: 8) {
                    Text(store.user.login)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("User ID: \(store.user.id)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Button {
                    store.send(.openProfileButtonTapped)
                } label: {
                    Label("View GitHub Profile", systemImage: "arrow.up.right.square")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)

                Spacer()
            }
        }
        .navigationTitle(store.user.login)
        .navigationBarTitleDisplayMode(.inline)
    }
}
