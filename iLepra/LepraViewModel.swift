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

    private var feedPage: UInt = 1
    @Published private(set) var feedPosts: [LepraPost] = []

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

        let feed = try await AF.request(
            "https://leprosorium.ru/api/feeds/\(feed.rawValue)",
            method: .get,
            parameters: [
                "page": feedPage,
                "per_page": 3,
                "threshold_rating": threshold.rawValue,
            ],
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            LepraFeed.self,
            decoder: decoder
        )
        .value

        await MainActor.run {
            self.feedPage += 1
            self.feedPosts += feed.posts
        }
    }
}
