//
//  LepraLoadingSectionView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraLoadingSectionView: View {
    @Binding var isLoading: Bool

    var body: some View {
        if isLoading {
            Section {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.accentColor)
                    Spacer()
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct LepraLoadingSectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraLoadingSectionView(isLoading: .constant(true))
        }
    }
}
