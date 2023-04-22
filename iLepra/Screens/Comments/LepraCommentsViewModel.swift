//
//  LepraCommentsViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Foundation

final class LepraCommentViewModel: ObservableObject, @unchecked Sendable {
    private let api: LepraAPI = .shared

    @Published var comments: [LepraComment] = []

    init() {
        if ProcessInfo.isRunningForPreviews {
            comments = (0 ..< 10).map { .init(id: $0) }
        }
    }

    func fetch(for post: LepraPost) async throws {
        let result: LepraComments = try await api.request(path: "api/posts/\(post.id)/comments")

        await MainActor.run {
            comments = result.comments
        }
    }
}
