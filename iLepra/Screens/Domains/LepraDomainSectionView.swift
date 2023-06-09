//
//  LepraDomainSectionView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftSoup
import SwiftUI

struct LepraDomainSectionView: View {
    @Binding var domain: LepraDomain

    var body: some View {
        Section {
            NavigationLink(value: domain) {
                VStack(alignment: .leading, spacing: 8) {
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
                            let title = (try? Entities.unescape(domain.title)) ?? domain.title
                            Text(title)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    let name = (try? Entities.unescape(domain.name)) ?? domain.name
                    Text(name)
                        .font(.callout)
                    Spacer()
                        .frame(height: 8)
                }
            }
        }
    }
}

struct LepraDomainSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                LepraDomainSectionView(domain: .constant(.init()))
            }
        }
    }
}
