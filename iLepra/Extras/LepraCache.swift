//
//  LepraCache.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import Foundation
import SDWebImageSwiftUI

struct LepraCache {
    init() {
        let cache = SDImageCache(namespace: "lepra")
        cache.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB memory
        cache.config.maxDiskSize = 50 * 1024 * 1024 // 50MB disk
        SDImageCachesManager.shared.addCache(cache)
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
    }
}
