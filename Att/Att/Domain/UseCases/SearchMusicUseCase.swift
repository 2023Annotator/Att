//
//  SearchMusicUseCase.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation

public struct SearchMusicUseCase: Sendable {
    private let repository: MusicSearchRepository

    public init(repository: MusicSearchRepository) {
        self.repository = repository
    }

    @discardableResult
    public func execute(term: String, limit: Int = 25) async throws -> [MusicInfo] {
        try await repository.search(term: term, limit: limit)
    }
}
