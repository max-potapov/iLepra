//
//  ProcessInfo+Preview.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Foundation

extension ProcessInfo {
    static let isRunningForPreviews: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
