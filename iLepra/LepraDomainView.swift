//
//  LepraDomainView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraDomainView: View {
    @EnvironmentObject var viewModel: LepraViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LepraDomainView_Previews: PreviewProvider {
    static var previews: some View {
        LepraDomainView()
            .environmentObject(LepraViewModel())
    }
}
