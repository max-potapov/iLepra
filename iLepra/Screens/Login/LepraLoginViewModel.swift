//
//  LepraLoginViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import SwiftUI

final class LepraLoginViewModel: ObservableObject, @unchecked Sendable {
    private let api: LepraAPI = .shared

    @AppStorage("username") private var username: String?
    @AppStorage("password") private var password: String?

    @Published private(set) var isAuthorized: Bool = false

    init() {
        guard !ProcessInfo.isRunningForPreviews else { return }

        if let username, let password {
            Task {
                do {
                    try await login(username: username, password: password)
                    await MainActor.run {
                        isAuthorized = true
                    }
                } catch {}
            }
        }
    }

    func login(username: String, password: String) async throws {
        try await api.login(username: username, password: password)
    }
}