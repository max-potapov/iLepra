//
//  LepraContentView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraContentView: View {
    @EnvironmentObject private var viewModel: LepraViewModel
    @State private var selection: Tab = .main
    @State private var sidebarSelection: Tab? = .main
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

    var body: some View {
        Group {
            if useSideBar {
                NavigationSplitView {
                    sidebarView
                } detail: {
                    selection.view
                }
            } else {
                tabBarView
            }
        }
        .onTapGesture(count: 2) {
            switch selection {
            case .main:
                viewModel.feedPosts = []
            case .domains:
                viewModel.domainPosts = []
            case .profile:
                viewModel.leper = .none
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
            selection = tab ?? .main
        }
        .navigationTitle("iLepra")
        #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }

    private var tabBarView: some View {
        TabView(selection: $selection) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view.tag(tab).tabItem {
                    Label(tab.title, systemImage: tab.imageName)
                }
            }
        }
        .onChange(of: selection) { tab in
            sidebarSelection = tab
        }
    }
}

extension LepraContentView {
    private enum Tab: Hashable, CaseIterable {
        case main
        case domains
        case profile

        var title: String {
            switch self {
            case .main:
                return "Главная"
            case .domains:
                return "Подлепры"
            case .profile:
                return "Профиль"
            }
        }

        var imageName: String {
            switch self {
            case .main:
                return "house"
            case .domains:
                return "list.dash"
            case .profile:
                return "brain.head.profile"
            }
        }

        var view: some View {
            switch self {
            case .main:
                return AnyView(LepraFeedView())
            case .domains:
                return AnyView(LepraDomainView())
            case .profile:
                return AnyView(LepraPreferencesView())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LepraContentView()
            .environmentObject(LepraViewModel())
    }
}
