//
//  SearchViewModelTests.swift
//  Att
//
//  Created by 황정현 on 8/12/25.
//

import XCTest
@testable import Att

final class SearchViewModelTests: XCTestCase {

    final class StubRepo: MusicSearchRepository {
        let result: Result<[MusicInfo], Error>
        init(result: Result<[MusicInfo], Error>) { self.result = result }
        func search(term: String, limit: Int) async throws -> [MusicInfo] {
            try result.get()
        }
    }

    final class StubImageLoader: ImageLoader {
        func cachedImage(for url: URL) -> UIImage? { nil }
        func loadImage(from url: URL,
                       targetPointSize: CGSize?,
                       screenScale: CGFloat) async throws -> UIImage {
            UIImage()
        }
    }

    struct DummyError: Error {}

    @MainActor
    func test_search_success_updates_results_and_loadingStates() async {
        let repo = StubRepo(result: .success([
            MusicInfo(id: "1", title: "Kanden", artist: "Yonezu Kenshi", artworkURL: nil)
        ]))
        let viewModel = SearchViewModel(
            searchMusic: SearchMusicUseCase(repository: repo),
            imageLoader: StubImageLoader()
        )

        await viewModel.search(term: "Kanden", limit: 5)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.results.count, 1)
        XCTAssertEqual(viewModel.results.first?.title, "Kanden")
    }

    @MainActor
    func test_search_failure_sets_errorMessage_and_stops_loading() async {
        let repo = StubRepo(result: .failure(DummyError()))
        let viewModel = SearchViewModel(
            searchMusic: SearchMusicUseCase(repository: repo),
            imageLoader: StubImageLoader()
        )

        await viewModel.search(term: "Kanden", limit: 5)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.results.isEmpty)
    }
}
