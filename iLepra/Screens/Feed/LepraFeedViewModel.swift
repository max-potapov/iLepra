//
//  LepraFeedViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Algorithms
import Foundation

final class LepraFeedViewModel: ObservableObject, @unchecked Sendable {
    private let api: LepraAPI = .shared
    private var page: UInt = 1
    private let perPage: Int = 42
    @Published var posts: [LepraPost] = []

    init() {
        if ProcessInfo.isRunningForPreviews {
            posts = (0 ..< 10).map { _ in .init() }
        }
    }

    func reset() {
        page = 1
        posts = []
    }

    func fetch(_ feed: LepraFeedType = .main, threshold: LepraThresholdRating = .nightmare) async throws {
        let result: LepraPosts = try await api.request(
            path: "api/feeds/\(feed.rawValue)",
            parameters: [
                "page": page,
                "per_page": perPage,
                "threshold_rating": threshold.rawValue,
            ]
        )

        let unique = Array((posts + result.posts).uniqued())
        await MainActor.run {
            page += 1
            posts = unique
        }
    }
}
