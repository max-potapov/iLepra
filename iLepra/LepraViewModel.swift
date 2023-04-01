//
//  LepraViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Alamofire
import Foundation
import SwiftUI

final class LepraViewModel: ObservableObject, @unchecked Sendable {
    @Published private(set) var auth: LepraAuth?
    @AppStorage("username") private var username: String?
    @AppStorage("password") private var password: String?

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
}
