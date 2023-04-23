//
//  LepraImageView.swift
//  iLepra
//
//  Created by Maxim Potapov on 10.04.2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct LepraImageView: View {
    let url: URL
    @State private var isPresented = false

    var body: some View {
        imageView
        #if os(iOS)
        .fullScreenCover(isPresented: $isPresented) {
            ZStack {
                Group {
                    Color.black
                    imageView
                }
                .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    Spacer()
                }
            }
        }
        #endif
    }

    var imageView: some View {
        AnimatedImage(url: url)
            .resizable()
            .scaledToFit()
            .frame(height: 400)
            .onTapGesture {
                isPresented.toggle()
            }
    }
}

struct LepraImageView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraImageView(url: .init(string: "https://picsum.photos/500/500")!)
        }
    }
}
