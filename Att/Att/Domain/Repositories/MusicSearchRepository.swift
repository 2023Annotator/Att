//
//  MusicSearchRepository.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation

public protocol MusicSearchRepository: Sendable {
    func search(term: String, limit: Int) async throws -> [MusicInfo]
}
