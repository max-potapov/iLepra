//
//  LepraContentView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraContentView: View {
    @StateObject private var feedViewModel: LepraFeedViewModel = .init()
    @StateObject private var moarViewModel: LepraMoarViewModel = .init()
    @StateObject private var domainsViewModel: LepraDomainsViewModel = .init()
    @StateObject private var profileViewModel: LepraProfileViewModel = .init()

    @State private var selection: LepraTab = .default

    @State private var navigationPathFeed: NavigationPath = .init()
    @State private var navigationPathMoar: NavigationPath = .init()
    @State private var navigationPathDomains: NavigationPath = .init()

    @State private var shouldReloadFeed: Bool = false
    @State private var shouldReloadMoar: Bool = false
    @State private var shouldReloadDomains: Bool = false
    @State private var shouldReloadProfile: Bool = false

    var body: some View {
        LepraTabView(
            feedView: view(for: .feed),
            moarView: view(for: .moar),
            domainsView: view(for: .domains),
            profileView: view(for: .profile),
            selection: $selection
        )
        .onTapGesture(count: 2) {
            switch selection {
            case .feed:
                shouldReloadFeed = true
            case .moar:
                shouldReloadMoar = true
            case .domains:
                shouldReloadDomains = true
            case .profile:
                shouldReloadProfile = true
            }
        }
    }

    private func view(for tab: LepraTab) -> some View {
        switch tab {
        case .feed:
            LepraFeedView(navigationPath: $navigationPathFeed, shouldReload: $shouldReloadFeed)
                .environmentObject(feedViewModel)
                .navigationTitle(tab.title)
                .eraseToAny()
        case .moar:
            LepraMoarView(navigationPath: $navigationPathMoar, shouldReload: $shouldReloadMoar)
                .environmentObject(moarViewModel)
                .navigationTitle(tab.title)
                .badge(moarViewModel.unreadCount)
                .eraseToAny()
        case .domains:
            LepraDomainsView(navigationPath: $navigationPathDomains, shouldReload: $shouldReloadDomains)
                .environmentObject(domainsViewModel)
                .navigationTitle(tab.title)
                .eraseToAny()
        case .profile:
            LepraProfileView(shouldReload: $shouldReloadProfile)
                .environmentObject(profileViewModel)
                .navigationTitle(tab.title)
                .eraseToAny()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LepraContentView()
    }
}
