//
//  Song+DomainMapper.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation
import MusicKit

extension Song {
    func toMusic() -> Music {
        return Music(
            title: title,
            artist: artistName,
            artworkURL: artwork?.url(width: 300, height: 300),
            previewURL: previewAssets?.first?.url
        )
    }
    
    func toMusicSource(musicId: UUID, vendor: MusicVendor, storefront: String) -> MusicSource {
        switch vendor {
        case .appleMusic:
            return MusicSource(
                musicId: musicId,
                musicVendor: vendor,
                vendorTrackId: self.id.rawValue,
                storefront: storefront,
                deeplinkURI: self.url,
                artworkURLTemplate: self.artwork?.url(width: 300, height: 300),
                previewURL: self.previewAssets?.first?.url,
                isrc: self.isrc
            )
        case .spotifyMusic:
            return MusicSource(
                musicId: musicId,
                musicVendor: vendor,
                vendorTrackId: self.id.rawValue,
                storefront: storefront,
                deeplinkURI: self.url,
                artworkURLTemplate: self.artwork?.url(width: 300, height: 300),
                previewURL: self.previewAssets?.first?.url,
                isrc: self.isrc
            )
        }
    }
}
