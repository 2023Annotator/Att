//
//  ImageLoader.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import UIKit

public protocol ImageLoader: Sendable {
    func cachedImage(for url: URL) -> UIImage?
    func loadImage(from url: URL,
                   targetPointSize: CGSize?,
                   screenScale: CGFloat) async throws -> UIImage
}
