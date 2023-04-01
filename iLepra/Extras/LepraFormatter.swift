//
//  LepraFormatter.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Foundation

final class LepraFormatter {
    static let shared: LepraFormatter = .init()

    lazy var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar.timeZone = .current
        formatter.dateTimeStyle = .named
        formatter.locale = .init(identifier: "ru")
        return formatter
    }()

    private init() {}
}
