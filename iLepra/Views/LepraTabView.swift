//
//  LepraTabView.swift
//  iLepra
//
//  Created by Maxim Potapov on 23.04.2023.
//

import SwiftUI

enum LepraTab: Hashable, CaseIterable {
    static let `default` = LepraTab.feed

    case feed
    case moar
    case domains
    case profile

    var title: String {
        switch self {
        case .feed:
            return "Главная"
        case .moar:
            return "Мои вещи"
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
        case .moar:
            return "bookmark"
        case .domains:
            return "list.dash"
        case .profile:
            return "brain.head.profile"
        }
    }
}

struct LepraTabView<LepraView: View>: View {
    let feedView: LepraView
    let moarView: LepraView
    let domainsView: LepraView
    let profileView: LepraView

    @Binding var selection: LepraTab
    @State private var sidebarSelection: LepraTab? = .default
    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    private var useTabBar: Bool {
        #if os(iOS)
            return horizontalSizeClass == .compact
        #else
            return false
        #endif
    }

    var body: some View {
        Group {
            if useTabBar {
                tabBarView
            } else {
                NavigationSplitView {
                    sidebarView
                } detail: {
                    view(for: selection)
                }
            }
        }
    }

    private var sidebarView: some View {
        List(selection: $sidebarSelection) {
            ForEach(LepraTab.allCases, id: \.self) { tab in
                Label(tab.title, systemImage: tab.imageName)
            }
        }
        .onChange(of: sidebarSelection) { tab in
            selection = tab ?? .default
        }
        .navigationTitle("iLepra")
        #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }

    private var tabBarView: some View {
        TabView(selection: $selection) {
            ForEach(LepraTab.allCases, id: \.self) { tab in
                view(for: tab).tag(tab).tabItem {
                    Label(tab.title, systemImage: tab.imageName)
                }
            }
        }
        .onChange(of: selection) { tab in
            sidebarSelection = tab
        }
    }

    private func view(for tab: LepraTab) -> some View {
        switch tab {
        case .feed:
            return feedView
        case .moar:
            return moarView
        case .domains:
            return domainsView
        case .profile:
            return profileView
        }
    }
}

struct LepraTabView_Previews: PreviewProvider {
    static var previews: some View {
        LepraTabView(
            feedView: EmptyView(),
            moarView: EmptyView(),
            domainsView: EmptyView(),
            profileView: EmptyView(),
            selection: .constant(.default)
        )
    }
}
