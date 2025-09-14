//
//  MusicSource.swift
//  Att
//
//  Created by 황정현 on 9/14/25.
//

import Foundation

struct MusicSource: Hashable, Sendable {
    let musicId: UUID
    let musicVendor: MusicVendor
    let vendorTrackId: String
    let storefront: String
    let deeplinkURI: URL?
    let artworkURLTemplate: URL?
    let previewURL: URL?
    let isrc: String?

    init(
        musicId: UUID,
        musicVendor: MusicVendor,
        vendorTrackId: String,
        storefront: String,
        deeplinkURI: URL? = nil,
        artworkURLTemplate: URL? = nil,
        previewURL: URL? = nil,
        isrc: String? = nil
    ) {
        self.musicId = musicId
        self.musicVendor = musicVendor
        self.vendorTrackId = vendorTrackId
        self.storefront = storefront
        self.deeplinkURI = deeplinkURI
        self.artworkURLTemplate = artworkURLTemplate
        self.previewURL = previewURL
        self.isrc = isrc
    }
}
