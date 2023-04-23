//
//  LepraProfileViewModel.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Foundation

final class LepraProfileViewModel: ObservableObject, @unchecked Sendable {
    @Published private(set) var leper: LepraUser?

    private let api: LepraAPI = .shared

    init() {
        if ProcessInfo.isRunningForPreviews {
            leper = .init()
        }
    }

    func reset() {
        leper = .none
    }

    func fetch() async throws {
        let result: LepraUser = try await api.request(path: "api/my")

        await MainActor.run {
            leper = result
        }
    }
}
