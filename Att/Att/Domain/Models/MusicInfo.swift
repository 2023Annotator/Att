//
//  MusicInfo.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Foundation

public struct MusicInfo: Hashable, Sendable {
    public let id: String
    public let title: String
    public let artist: String
    public let artworkURL: URL?
    public let previewURL: URL?

    public init(
        id: String,
        title: String,
        artist: String,
        artworkURL: URL?,
        previewURL: URL?
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.previewURL = previewURL
    }

    public var artistAndTitle: String { "\(artist) - \(title)" }
}
