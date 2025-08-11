//
//  AppleMusicSearchRepository.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation
import MusicKit

public final class AppleMusicSearchRepository: MusicSearchRepository {
    public init() {}

    public func search(term: String, limit: Int) async throws -> [MusicInfo] {
        var request = MusicCatalogSearchRequest(term: term, types: [Song.self])
        request.limit = limit

        do {
            let response = try await request.response()
            let songs = response.songs
            return songs.map { $0.toDomain() }
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
