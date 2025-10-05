//
//  AppleMusicSearchRepository.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation
import MusicKit

public final class AppleMusicSearchRepository: MusicSearchRepository {
    private let vendor: MusicVendor = .appleMusic
    init() {}

    func search(term: String, limit: Int, storefront: String) async throws -> [MusicInfo] {
        var request = MusicCatalogSearchRequest(term: term, types: [Song.self])
        request.limit = limit

        do {
            let response = try await request.response()
            let musicInfos = response.songs.map { song -> MusicInfo in
                let music = song.toMusic()
                let source = song.toMusicSource(musicId: music.id, vendor: vendor, storefront: storefront)
                return MusicInfo(music: music, source: source)
            }
            return musicInfos
        } catch {
            throw await mapErrorToDomain(error)
        }
    }
}

private func mapErrorToDomain(_ error: Error) async -> DomainError {
    if error is DecodingError { return .invalidData }

    if error is URLError || (error as NSError).domain == NSURLErrorDomain {
        return .network
    }

    let status = MusicAuthorization.currentStatus
    if status == .denied || status == .restricted { return .unauthorized }

    return .unknown
}
