//
//  LepraDomainsViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Algorithms
import Foundation

final class LepraDomainsViewModel: ObservableObject {
    @Published var domains: [LepraDomain] = []
    @Published var posts: [LepraPost] = []

    private let api: LepraAPI = .shared
    private var currentDomain: LepraDomain?
    private var page: UInt = 1
    private let perPage: UInt = 13
    private var postsPage: UInt = 1
    private let postsPerPage: UInt = 13

    init() {
        if ProcessInfo.isRunningForPreviews {
            domains = (0 ..< 4).map { _ in .init() }
            posts = (0 ..< 10).map { _ in .init() }
        }
    }

    func reset() {
        currentDomain = .none
        page = 1
        domains = []
        postsPage = 1
        posts = []
    }

    func fetch() async throws {
        let result: LepraDomains = try await api.request(
            path: "api/domains",
            parameters: [
                "page": page,
                "per_page": perPage,
            ]
        )

        let unique = Array((domains + result.domains).uniqued())
        await MainActor.run {
            page += 1
            domains = unique
        }
    }

    func setCurrentDomain(_ domain: LepraDomain) {
        guard currentDomain != domain else { return }

        currentDomain = domain
        postsPage = 1
        posts = []
    }

    func fetchPosts(threshold: LepraThresholdRating = .nightmare) async throws {
        guard let currentDomain else { return }

        let result: LepraPosts = try await api.request(
            path: "api/domains/\(currentDomain.prefix)/posts",
            parameters: [
                "page": postsPage,
                "per_page": postsPerPage,
                "threshold_rating": threshold.rawValue,
            ]
        )

        let unique = Array((posts + result.posts).uniqued())
        await MainActor.run {
            postsPage += 1
            posts = unique
        }
    }
}
