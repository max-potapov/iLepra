//
//  WebImageProvider.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Combine
import Foundation
import MarkdownUI
import SDWebImageSwiftUI
import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

struct WebImageProvider: InlineImageProvider {
    func image(with url: URL, label _: String) async throws -> Image {
        #if os(iOS)
            let geometry = await UIScreen.main.bounds
        #elseif os(macOS)
            let geometry = CGRect(origin: .init(x: 0, y: 0), size: .init(width: 500, height: 500))
        #endif

        let image = try await withCheckedThrowingContinuation { continuation in
            let maxWidth = geometry.size.width * 0.8
            let maxHeight = 300.0

            let transformer = SDImageResizingTransformer(size: .init(width: maxWidth, height: maxHeight), scaleMode: .aspectFit)
            SDWebImageManager.shared.loadImage(with: url, context: [.imageTransformer: transformer], progress: .none) { image, _, error, _, _, _ in
                if let image {
                    continuation.resume(with: .success(image))
                    return
                }
                if let error {
                    continuation.resume(with: .failure(error))
                    return
                }
            }
        }

        #if os(iOS)
            return Image(uiImage: image)
        #elseif os(macOS)
            return Image(nsImage: image)
        #endif
    }
}

extension InlineImageProvider where Self == WebImageProvider {
    static var webImage: Self {
        .init()
    }
}
