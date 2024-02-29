//
//  EnvironmentValues+ImageCache.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

