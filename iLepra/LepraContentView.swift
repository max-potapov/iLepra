//
//  LepraContentView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraContentView: View {
    @State private var selection: Tab = .feed
    @State private var sidebarSelection: Tab? = .feed
    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    private var useSideBar: Bool {
        #if os(iOS)
            return horizontalSizeClass != .compact
        #else
            return true
        #endif
    }

    @State private var shouldReloadMain: Bool = false
    @State private var shouldReloadDomains: Bool = false
    @State private var shouldReloadProfile: Bool = false

    var body: some View {
        Group {
            if useSideBar {
                NavigationSplitView {
                    sidebarView
                } detail: {
                    tabView(selection)
                }
            } else {
                tabBarView
            }
        }
        .onTapGesture(count: 2) {
            switch selection {
            case .feed:
                shouldReloadMain = true
            case .domains:
                shouldReloadDomains = true
            case .profile:
                shouldReloadProfile = true
            }
        }
    }

    private var sidebarView: some View {
        List(selection: $sidebarSelection) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Label(tab.title, systemImage: tab.imageName)
            }
        }
        .onChange(of: sidebarSelection) { tab in
            selection = tab ?? .feed
        }
        .navigationTitle("iLepra")
        #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }

    private var tabBarView: some View {
        TabView(selection: $selection) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabView(tab).tag(tab).tabItem {
                    Label(tab.title, systemImage: tab.imageName)
                }
            }
        }
        .onChange(of: selection) { tab in
            sidebarSelection = tab
        }
    }

    private func tabView(_ tab: Tab) -> some View {
        switch tab {
        case .feed:
            return LepraFeedView(shouldReload: $shouldReloadMain)
                .navigationTitle(tab.title)
                .eraseToAny()
        case .domains:
            return LepraDomainView(shouldReload: $shouldReloadDomains)
                .navigationTitle(tab.title)
                .eraseToAny()
        case .profile:
            return LepraProfileView(shouldReload: $shouldReloadProfile)
                .navigationTitle(tab.title)
                .eraseToAny()
        }
    }
}

extension LepraContentView {
    private enum Tab: Hashable, CaseIterable {
        case feed
        case domains
        case profile

        var title: String {
            switch self {
            case .feed:
                return "Главная"
            case .domains:
                return "Подлепры"
            case .profile:
                return "Профиль"
            }
        }

        var imageName: String {
            switch self {
            case .feed:
                return "house"
            case .domains:
                return "list.dash"
            case .profile:
                return "brain.head.profile"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LepraContentView()
    }
}
