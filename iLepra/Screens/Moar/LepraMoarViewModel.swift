//
//  LepraMoarViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

final class LepraMoarViewModel: ObservableObject {
    @Published var unreadCount: Int = 0
    @Published var posts: [LepraPost] = []

    private let api: LepraAPI = .shared

    init() {
        if ProcessInfo.isRunningForPreviews {
            posts = (0 ..< 9).map { _ in .init() }
        } else {
            Task {
                try await fetch()
            }
        }
    }

    func reset() {
        posts = []
    }

    func fetch() async throws {
        let result: AjaxMoar = try await api.request(
            path: "ajax/interest/moar",
            method: .post,
            parameters: [
                "sort": 0,
                "period": 30,
                "unread": 0,
            ]
        )

        let unreadCount: Int = result.unreadCount.reduce(0, +)
        let posts: [LepraPost] = result.docs.map {
            .init(
                body: $0.body,
                commentsCount: $0.commentsCount,
                created: $0.created,
                golden: $0.golden.boolValue,
                id: $0.id,
                rating: $0.rating,
                unreadCommentsCount: $0.unreadCommentsCount,
                user: .init(
                    active: $0.user.active.boolValue,
                    deleted: $0.user.deleted.boolValue,
                    gender: $0.user.gender,
                    id: $0.id,
                    isIgnored: $0.user.ignored?.boolValue,
                    login: $0.user.login,
                    rank: $0.user.rank
                ),
                userVote: $0.userVote?.vote,
                voteWeight: $0.voteWeight
            )
        }

        await MainActor.run {
            self.unreadCount = unreadCount
            self.posts = posts
        }
    }
}
