//
//  SearchMusicUseCase.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation

public struct SearchMusicUseCase: Sendable {
    private let repository: MusicSearchRepository
    private let storefrontProvider: StorefrontProviding

    init(
        repository: MusicSearchRepository,
        storefrontProvider: StorefrontProviding = MusicKitStorefrontProvider()
    ) {
        self.repository = repository
        self.storefrontProvider = storefrontProvider
    }

    @discardableResult
    func execute(
        term: String,
        limit: Int = 25,
        storefront override: String? = nil,
        forceRefreshStorefront: Bool = false
    ) async throws -> [MusicInfo] {
        if let storefront = override {
            return try await repository.search(term: term, limit: limit, storefront: storefront)
        }
        
        let storefront = try await storefrontProvider.currentStorefront(forceRefresh: forceRefreshStorefront)
        return try await repository.search(term: term, limit: limit, storefront: storefront)
    }
}
