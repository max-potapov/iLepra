//
//  LepraVotesDetailsViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 26.04.2023.
//

import Algorithms
import Foundation

final class LepraVotesDetailsViewModel: ObservableObject {
    private let api: LepraAPI = .shared
    private let limit: Int = 15

    @Published var votes: AjaxVotes?

    init() {
        if ProcessInfo.isRunningForPreviews {
            votes = .init()
        }
    }

    func reset() {
        votes = .none
    }

    func vote(postID: LepraPost.ID, value: Int) async throws {
        _ = try await vote(type: "posts", id: postID, value: value) as LepraPost
    }

    func vote(commentID: LepraComment.ID, value: Int) async throws {
        _ = try await vote(type: "comments", id: commentID, value: value) as LepraComment
    }

    private func vote<T: Decodable>(type: String, id: Int, value: Int) async throws -> T where T: Decodable {
        try await api.request(
            path: "api/\(type)/\(id)/vote",
            method: .post,
            parameters: [
                "vote": value,
            ]
        )
    }

    func fetchVotes(postID: LepraPost.ID) async throws {
        try await fetchVotes(type: "post", id: postID)
    }

    func fetchVotes(commentID: LepraComment.ID) async throws {
        try await fetchVotes(type: "comment", id: commentID)
    }

    func fetchVotes(userID: LepraUser.ID) async throws {
        try await fetchVotes(type: "user", id: userID)
    }

    private func fetchVotes(type: String, id: LepraPost.ID) async throws {
        if votes != nil, votes?.offset == nil {
            return
        }

        let response: AjaxVotes = try await api.request(
            path: type == "user" ? "ajax/user/karma/list" : "ajax/vote/list",
            method: .post,
            parameters: [
                type: id,
                "limit": limit,
                "offset": votes?.offset ?? 0,
            ]
        )

        let result: AjaxVotes
        if let votes {
            result = .init(
                cons: .init((votes.cons + response.cons).uniqued()),
                consCount: response.consCount,
                karma: response.karma,
                offset: response.offset,
                pros: .init((votes.pros + response.pros).uniqued()),
                prosCount: response.prosCount,
                rating: response.rating,
                status: response.status,
                totalCount: response.totalCount
            )
        } else {
            result = response
        }
        await MainActor.run {
            votes = result
        }
    }
}
