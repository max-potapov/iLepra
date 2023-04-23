//
//  LepraDomainViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Algorithms
import Foundation

final class LepraDomainViewModel: ObservableObject, @unchecked Sendable {
    private let api: LepraAPI = .shared

    @Published var domains: [LepraDomain] = []

    private var currentDomain: LepraDomain?
    private var page: UInt = 1
    private let perPage = 33
    @Published var posts: [LepraPost] = []

    init() {
        if ProcessInfo.isRunningForPreviews {
            domains = (0 ..< 4).map { _ in .init() }
            posts = (0 ..< 10).map { _ in .init() }
        }
    }

    func reset() {
        currentDomain = .none
        domains = []
        page = 1
        posts = []
    }

    func fetch() async throws {
        let result: LepraDomains = try await api.request(path: "api/domains")

        await MainActor.run {
            domains = result.domains
        }
    }

    func setCurrentDomain(_ domain: LepraDomain) {
        guard currentDomain != domain else { return }

        currentDomain = domain
        page = 1
        posts = []
    }

    func fetchPosts(threshold: LepraThresholdRating = .nightmare) async throws {
        guard let currentDomain else { return }

        let result: LepraPosts = try await api.request(
            path: "api/domains/\(currentDomain.prefix)/posts",
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
