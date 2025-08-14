//
//  Song+DomainMapper.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation
import MusicKit

extension Song {
    func toDomain() -> MusicInfo {
        MusicInfo(
            id: id.rawValue,
            title: title,
            artist: artistName,
            artworkURL: artwork?.url(width: 300, height: 300),
            previewURL: previewAssets?.first?.url
        )
    }
}
