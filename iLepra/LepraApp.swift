//
//  LepraApp.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Combine
import SwiftUI

@main
struct LepraApp: App {
    @StateObject var viewModel: LepraViewModel = .init()
    private var disposables: Set<AnyCancellable> = []

    var body: some Scene {
        WindowGroup {
            if viewModel.auth == nil {
                LepraLoginView()
                    .environmentObject(viewModel)
            } else {
                LepraContentView()
                    .environmentObject(viewModel)
            }
        }
        #if os(macOS)
        .defaultSize(width: 500, height: 500)
        #endif
    }
}
