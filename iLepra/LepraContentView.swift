//
//  LepraContentView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraContentView: View {
    @EnvironmentObject var viewModel: LepraViewModel

    var body: some View {
        TabView {
            LepraFeedView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
                .environmentObject(viewModel)
            LepraDomainView()
                .tabItem {
                    Label("Подлепры", systemImage: "list.dash")
                }
                .environmentObject(viewModel)
            LepraPreferencesView()
                .tabItem {
                    Label("Профиль", systemImage: "brain.head.profile")
                }
                .environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LepraContentView()
            .environmentObject(LepraViewModel())
    }
}
