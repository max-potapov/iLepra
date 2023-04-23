//
//  LepraAPI.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Alamofire
import Foundation
import OSLog

actor LepraAPI {
    static let shared: LepraAPI = .init()

    private let baseURL: URL = .init(string: "https://leprosorium.ru")!

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LepraAPI.self)
    )

    private var auth: LepraAuth?

    private init() {}

    func login(username: String, password: String) async throws {
        guard !username.isEmpty, !password.isEmpty else { throw Error.youShallNotPass }

        logger.log(level: .debug, "🚀 api/auth/login")

        auth = try await AF.request(
            baseURL.appending(path: "api/auth/login"),
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
    }

    func logout() {
        auth = .none
    }

    func request<T>(
        path: String,
        method: HTTPMethod = .get,
        parameters: [String: Any] = [:]
    ) async throws -> T where T: Decodable {
        guard let auth else { throw Error.youShallNotPass }

        logger.log(level: .debug, "🚀 \(path)")

        return try await AF.request(
            baseURL.appending(path: path),
            method: method,
            parameters: parameters,
            headers: [
                "X-Futuware-UID": auth.uid,
                "X-Futuware-SID": auth.sid,
            ]
        )
        .validate()
        .serializingDecodable(
            T.self,
            decoder: decoder
        )
        .value
    }
}

extension LepraAPI {
    enum Error: Swift.Error {
        case youShallNotPass
    }
}
