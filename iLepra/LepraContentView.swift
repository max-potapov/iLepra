//
//  LepraContentView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraContentView: View {
    @EnvironmentObject var viewModel: LepraViewModel
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            LepraFeedView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
                .tag(0)
            LepraDomainView()
                .tabItem {
                    Label("Подлепры", systemImage: "list.dash")
                }
                .tag(1)
            LepraPreferencesView()
                .tabItem {
                    Label("Профиль", systemImage: "brain.head.profile")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LepraContentView()
            .environmentObject(LepraViewModel())
    }
}
