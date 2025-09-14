//
//  TrackSource+.swift
//  Att
//
//  Created by 황정현 on 9/14/25.
//

import Foundation

extension TrackSource {
    func toDomain() -> MusicSource? {
        guard
            let rawVendor = vendor,
            let vendor = MusicVendor(rawValue: rawVendor),
            let vendorTrackId = vendorTrackId,
            let storefront = storefront,
            let musicId = track?.id
        else {
            return nil
        }

        let artworkURLTemplateURL = artworkURLTemplate.flatMap(URL.init(string:))
        let previewURLURL = previewURL.flatMap(URL.init(string:))

        guard let selfId = id else { return nil }

        return MusicSource(
            musicId: musicId,
            musicVendor: vendor,
            vendorTrackId: vendorTrackId,
            storefront: storefront,
            deeplinkURI: deeplinkURI,
            artworkURLTemplate: artworkURLTemplateURL,
            previewURL: previewURLURL,
            isrc: isrc
        )
    }

    /// Domain -> TrackSource (필수 필드 세팅). 링크는 별도 함수/헬퍼에서!
    func apply(from src: MusicSource) {
        self.vendor = src.musicVendor.rawValue
        self.vendorTrackId = src.vendorTrackId

        // 선택
        self.storefront = src.storefront
        self.deeplinkURI = src.deeplinkURI
        self.artworkURLTemplate = src.artworkURLTemplate?.absoluteString
        self.previewURL = src.previewURL?.absoluteString
        self.isrc = src.isrc
    }

    func apply(from src: MusicSource, linkTo track: Track) {
        apply(from: src)
        self.track = track
    }
}

enum CoreDataFieldError: Error { case missing(String) }

extension TrackSource {
    public var idReq: UUID {
        get { guard let item = id else { preconditionFailure("TrackSource.id missing") }; return item }
        set { id = newValue }
    }
    public var vendorReq: String {
        get { guard let item = vendor else { preconditionFailure("TrackSource.vendor missing") }; return item }
        set { vendor = newValue }
    }
    public var vendorTrackIdReq: String {
        get { guard let item = vendorTrackId else { preconditionFailure("TrackSource.vendorTrackId missing") }; return item }
        set { vendorTrackId = newValue }
    }
    public var trackReq: Track {
        get { guard let item = track else { preconditionFailure("TrackSource.track missing") }; return item }
        set { track = newValue }
    }

    public var artworkURLTemplateDef: String { artworkURLTemplate ?? "" }
    public var deeplinkURIDef: URL { deeplinkURI ?? URL(string: "about:blank")! }
    public var previewURLDef: String { previewURL ?? "" }
    public var storefrontDef: String { storefront ?? "" }
    public var isrcDef: String { isrc ?? "" }

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        if id == nil { id = UUID() }
    }
}
