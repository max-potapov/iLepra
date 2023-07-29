//
//  LepraImageView.swift
//  iLepra
//
//  Created by Maxim Potapov on 10.04.2023.
//

import Kingfisher
import SwiftUI

#if os(iOS)
    typealias AnimatedImage = KFAnimatedImage

    extension AnimatedImage {
        func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Self {
            self
        }
    }

#else
    typealias AnimatedImage = KFImage
#endif

struct LepraImageView: View {
    let url: URL
    @State private var isPresented = false

    var body: some View {
        previewImageView
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

    var previewImageView: some View {
        imageView
            .frame(height: 400)
    }

    var imageView: some View {
        AnimatedImage(url)
            .resizable()
            .scaledToFit()
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
