//
//  LepraEmptyContentPlaceholderView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraEmptyContentPlaceholderView: View {
    let onAppear: () -> Void

    var body: some View {
        ProgressView()
            .tint(.accentColor)
            .onAppear {
                onAppear()
            }
    }
}

struct LepraProgress_Previews: PreviewProvider {
    static var previews: some View {
        LepraEmptyContentPlaceholderView(onAppear: {})
    }
}
