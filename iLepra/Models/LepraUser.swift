//
//  LepraUser.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Foundation

// swiftformat:sort
struct LepraUser: Codable, Identifiable, Hashable {
    let active: Bool
    let deleted: Bool
    let gender: LepraGender
    let id: Int
    let isIgnored: Bool?
    let login: String
    let rank: String?

    func wroteOnceText(when: Date) -> AttributedString {
        let text = [
            gender == .male ? "Написал" : "Написала",
            rank,
            deleted ? "~~`\(login)`~~" : "`\(login)`",
            LepraFormatter.shared.relativeDateTimeFormatter.localizedString(for: when, relativeTo: .now),
        ]
        .compactMap { $0 }
        .joined(separator: " ")

        do {
            return try .init(markdown: text)
        } catch {
            return .init(stringLiteral: text)
        }
    }
}
