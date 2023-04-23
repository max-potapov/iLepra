//
//  LepraCommentsViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Foundation

final class LepraCommentsViewModel: ObservableObject, @unchecked Sendable {
    @Published private(set) var comments: [LepraComment] = []

    private let api: LepraAPI = .shared

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
