//
//  LepraFeedView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraFeedView: View {
    @EnvironmentObject var viewModel: LepraViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LepraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LepraFeedView()
            .environmentObject(LepraViewModel())
    }
}
