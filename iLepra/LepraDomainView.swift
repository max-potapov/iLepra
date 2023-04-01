//
//  LepraDomainView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import HTMLEntities
import SwiftUI

struct LepraDomainView: View {
    @EnvironmentObject var viewModel: LepraViewModel
    @State private var isLoading = false

    var body: some View {
        if viewModel.domains.isEmpty {
            ProgressView()
                .tint(.accentColor)
                .onAppear {
                    fetch()
                }
        } else {
            List {
                ForEach(viewModel.domains.indices, id: \.self) { index in
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            let domain = viewModel.domains[index]
                            HStack(spacing: 16) {
                                AsyncImage(url: domain.logoUrl) { image in
                                    image.resizable().clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 64, height: 64)

                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(domain.prefix)
                                        .font(.title)
                                    Text(domain.title.htmlUnescape())
                                        .font(.subheadline)
                                    Spacer()
                                }
                            }

                            Text(domain.name.htmlUnescape())
                                .font(.callout)
                            Spacer()
                                .frame(height: 8)
                        }
                    }
                }

                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .tint(.accentColor)
                        Spacer()
                    }
                }
            }
            #if os(macOS)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            #endif
            #if os(iOS)
            .listStyle(.insetGrouped)
            #endif
        }
    }

    func fetch() {
        guard !isLoading else { return }

        defer {
            isLoading = false
        }

        isLoading = true

        Task {
            try await viewModel.fetchDomains()
        }
    }
}

struct LepraDomainView_Previews: PreviewProvider {
    static var previews: some View {
        LepraDomainView()
            .environmentObject(LepraViewModel())
    }
}
