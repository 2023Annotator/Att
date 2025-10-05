//
//  SearchViewModel.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation
import UIKit

@MainActor
final class SearchViewModel: ObservableObject {
    @Published private(set) var results: [MusicInfo] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let searchMusic: SearchMusicUseCase
    private let imageLoader: ImageLoader

    init(searchMusic: SearchMusicUseCase, imageLoader: ImageLoader) {
        self.searchMusic = searchMusic
        self.imageLoader = imageLoader
    }

    func search(term: String, limit: Int = 25) async {
        let query = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { results = []; return }
        isLoading = true; errorMessage = nil
        do {
            results = try await searchMusic.execute(term: query, limit: limit)
        } catch {
            errorMessage = (error as NSError).localizedDescription
        }
        isLoading = false
    }

    func loadArtwork(for item: Music) async -> UIImage? {
        guard let url = item.artworkURL else { return nil }
        return try? await imageLoader.loadImage(from: url,
                                                targetPointSize: CGSize(width: 500, height: 500),
                                                screenScale: UIScreen.main.scale)
    }
}
