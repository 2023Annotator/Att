//
//  Track+.swift
//  Att
//
//  Created by 황정현 on 9/7/25.
//

import Foundation

extension Track {
    func toDomain() -> Music? {
        return Music(
            id: idReq,
            title: titleReq,
            artist: primaryArtistNameReq,
            artworkURL: artworkURLReq.flatMap(URL.init(string:)),
            previewURL: previewURLReq.flatMap(URL.init(string:))
        )
    }

    func apply(from music: Music) {
        self.title = music.title
        self.primaryArtistName = music.artist
        self.artworkURL = music.artworkURL?.absoluteString
        self.previewURL = music.previewURL?.absoluteString
    }
}

extension Track {
    public var artworkURLReq: String? {
        get { artworkURL }
        set { artworkURL = newValue }
    }

    public var durationMsReq: Int {
        get { Int(durationMs) }
        set { durationMs = Int64(clamping: newValue) }
    }

    public var idReq: UUID {
        get {
            guard let idValue = id else {
                preconditionFailure("Track.id must be set (or filled in awakeFromInsert)")
            }
            return idValue
        }
        set { id = newValue }
    }

    public var isrcReq: String? {
        get { isrc }
        set { isrc = newValue }
    }

    public var previewURLReq: String? {
        get { previewURL }
        set { previewURL = newValue }
    }

    public var primaryArtistNameReq: String {
        get {
            guard let name = primaryArtistName else {
                preconditionFailure("Track.primaryArtistName must be set (or filled in apply)")
            }
            return name
        }
        set { primaryArtistName = newValue }
    }

    public var titleReq: String {
        get {
            guard let value = title else {
                preconditionFailure("Track.title must be set (or filled in apply)")
            }
            return value
        }
        set { title = newValue }
    }

    public var dailyRecordsReq: Set<DailyRecord> {
        get { (dailyRecords as? Set<DailyRecord>) ?? [] }
        set { dailyRecords = newValue as NSSet }
    }

    public var sourcesReq: Set<TrackSource> {
        get { (sources as? Set<TrackSource>) ?? [] }
        set { sources = newValue as NSSet }
    }

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        if id == nil { id = UUID() }
    }
}
