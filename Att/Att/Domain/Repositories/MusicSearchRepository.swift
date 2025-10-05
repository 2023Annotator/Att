//
//  MusicSearchRepository.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation

protocol MusicSearchRepository: Sendable {
    func search(term: String, limit: Int, storefront: String) async throws -> [MusicInfo]
}
