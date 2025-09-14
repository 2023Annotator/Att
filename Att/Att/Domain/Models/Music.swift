//
//  Music.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Foundation

struct Music: Hashable, Sendable {
    let id: UUID
    let title: String
    let artist: String
    let artworkURL: URL?
    let previewURL: URL?

    init(
        id: UUID = UUID(),
        title: String,
        artist: String,
        artworkURL: URL? = nil,
        previewURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.previewURL = previewURL
    }

    public var artistAndTitle: String { "\(artist) - \(title)" }
}
