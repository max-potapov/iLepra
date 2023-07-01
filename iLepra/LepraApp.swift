//
//  LepraApp.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

// swiftformat:sort
enum LepraWindowID: String {
    case chart
    case table
}

@main
struct LepraApp: App {
    private let cache: LepraCache = .init()
    @StateObject private var viewModel: LepraLoginViewModel = .init()

    var body: some Scene {
        WindowGroup {
            if !viewModel.isAuthorized {
                LepraLoginView()
                    .environmentObject(viewModel)
            } else {
                LepraContentView()
            }
        }
        #if os(macOS)
            WindowGroup("Стата", id: LepraWindowID.chart.rawValue, for: [LepraComment].self) { $value in
                LepraChartView(comments: .constant(value ?? []))
            }
            .defaultSize(width: 1000, height: 500)

            WindowGroup("Стата", id: LepraWindowID.table.rawValue, for: [LepraComment].self) { $value in
                LepraTableView(comments: .constant(value ?? []))
            }
            .defaultSize(width: 500, height: 700)
        #endif
    }
}
