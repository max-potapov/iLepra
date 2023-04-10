//
//  LepraViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Alamofire
import Foundation
import SDWebImageSwiftUI
import SwiftUI

final class LepraViewModel: ObservableObject, @unchecked Sendable {
    @Published private(set) var auth: LepraAuth?
    @AppStorage("username") private var username: String?
    @AppStorage("password") private var password: String?

    private var feedPostsPage: UInt = 1
    @Published var feedPosts: [LepraPost] = []

    @Published var domains: [LepraDomain] = []

    private var currentDomain: LepraDomain?
    private var domainPostsPage: UInt = 1
    @Published var domainPosts: [LepraPost] = []

    @Published var postComments: [LepraComment] = []

    @Published var leper: LepraUser?

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    init() {
        guard
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"
        else {
            feedPosts = (0 ..< 10).map { _ in .init() }
            domains = (0 ..< 4).map { _ in .init() }
            domainPosts = (0 ..< 10).map { _ in .init() }
            postComments = (0 ..< 10).map { .init(id: $0) }
            leper = .init()
            return
        }

        let cache = SDImageCache(namespace: "lepra")
        cache.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB memory
        cache.config.maxDiskSize = 50 * 1024 * 1024 // 50MB disk
        SDImageCachesManager.shared.addCache(cache)
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared

        if let username, let password {
            Task {
                try await login(username: username, password: password)
            }
        }
    }

    func login(username: String, password: String) async throws {
        guard !username.isEmpty, !password.isEmpty else { return }

        let auth = try await AF.request(
            "https://leprosorium.ru/api/auth/login",
            method: .post,
            parameters: [
                "username": username,
                "password": password,
            ],
            encoder: JSONParameterEncoder.prettyPrinted
        )
        .validate()
        .serializingDecodable(LepraAuth.self)
        .value

        await MainActor.run {
            self.auth = auth
            self.username = username
            self.password = password
        }
    }

    func fetchFeed(_ feed: LepraFeedType = .main, threshold: LepraThresholdRating = .hardcore) async throws {
        guard let auth else { return }

#if os(iOS)
        let perPage = 3
#elseif os(macOS)
        let perPage = 33
#endif

        let result = try await AF.request(
            "https://leprosorium.ru/api/feeds/\(feed.rawValue)",
            method: .get,
            parameters: [
                "page": feedPostsPage,
                "per_page": perPage,
                "threshold_rating": threshold.rawValue,
            ],
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            LepraPosts.self,
            decoder: decoder
        )
        .value

        await MainActor.run {
            self.feedPostsPage += 1
            self.feedPosts += result.posts
        }
    }

    func fetchDomains() async throws {
        guard let auth else { return }

        let domains = try await AF.request(
            "https://leprosorium.ru/api/domains",
            method: .get,
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            LepraDomains.self,
            decoder: decoder
        )
        .value

        await MainActor.run {
            self.domains = domains.domains
        }
    }

    func setCurrentDomain(_ domain: LepraDomain) {
        guard currentDomain != domain else { return }

        currentDomain = domain
        domainPostsPage = 1
        domainPosts = []
    }

    func fetchPosts(threshold: LepraThresholdRating = .hardcore) async throws {
        guard let auth else { return }
        guard let currentDomain else { return }

        #if os(iOS)
            let perPage = 3
        #elseif os(macOS)
            let perPage = 33
        #endif

        let result = try await AF.request(
            "https://leprosorium.ru/api/domains/\(currentDomain.prefix)/posts",
            method: .get,
            parameters: [
                "page": domainPostsPage,
                "per_page": perPage,
                "threshold_rating": threshold.rawValue,
            ],
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            LepraPosts.self,
            decoder: decoder
        )
        .value

        await MainActor.run {
            self.domainPostsPage += 1
            self.domainPosts += result.posts
        }
    }

    func fetchComments(for post: LepraPost) async throws {
        guard let auth else { return }

        let result = try await AF.request(
            "https://leprosorium.ru/api/posts/\(post.id)/comments",
            method: .get,
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            LepraComments.self,
            decoder: decoder
        )
        .value

        await MainActor.run {
            self.postComments = result.comments
        }
    }

    func fetchMe() async throws {
        guard let auth else { return }

        let result = try await AF.request(
            "https://leprosorium.ru/api/my",
            method: .get,
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            LepraUser.self,
            decoder: decoder
        )
        .value

        await MainActor.run {
            self.leper = result
        }
    }
}
