//
//  LepraUser.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Foundation

struct LepraUser: Codable, Identifiable, Hashable {
    let active: Bool
    let deleted: Bool
    let gender: LepraGender
    let id: Int
    let isIgnored: Bool?
    let login: String
    let rank: String?

    var kind: String {
        let prefix = id % 2 == 0 ? "" : "не"
        let suffix = gender == .male ? "к" : "ца"
        return "\(prefix)чётни\(suffix)"
    }

    func wroteOnceText(when: Date, useAbsoluteTime: Bool) -> AttributedString {
        let text = [
            gender == .male ? "Написал" : "Написала",
            rank,
            deleted ? "~~`\(login)`~~" : "`\(login)`",
            useAbsoluteTime
                ? LepraFormatter.shared.absoluteDateTimeFormatter.string(from: when)
                : LepraFormatter.shared.relativeDateTimeFormatter.localizedString(for: when, relativeTo: .now),
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
