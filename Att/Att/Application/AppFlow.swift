//
//  AppFlow.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

enum AppFlow {
    @MainActor static func makeSearchViewModel() -> SearchViewModel {
        let repo: MusicSearchRepository = AppleMusicSearchRepository()
        let useCase = SearchMusicUseCase(repository: repo)
        let imageLoader = DefaultImageLoader()
        return SearchViewModel(searchMusic: useCase, imageLoader: imageLoader)
    }
}
