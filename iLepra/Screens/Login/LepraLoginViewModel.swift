//
//  LepraLoginViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import SwiftUI

final class LepraLoginViewModel: ObservableObject {
    @Published private(set) var isAuthorized: Bool = false

    @AppStorage("username") private var username: String?
    @AppStorage("password") private var password: String?

    private let api: LepraAPI = .shared

    init() {
        guard !ProcessInfo.isRunningForPreviews else { return }

        if let username, let password {
            Task {
                try await login(username: username, password: password)
            }
        }
    }

    func login(username: String, password: String) async throws {
        try await api.login(username: username, password: password)
        await MainActor.run {
            self.username = username
            self.password = password
            isAuthorized = true
        }
    }
}
