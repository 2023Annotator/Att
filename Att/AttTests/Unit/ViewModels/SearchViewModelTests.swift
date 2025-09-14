//
//  SearchViewModelTests.swift
//  Att
//
//  Created by 황정현 on 8/12/25.
//

import XCTest
import UIKit
@testable import Att

final class StubRepo: MusicSearchRepository {
    let result: Result<[MusicInfo], Error>
    private(set) var captured: (term: String, limit: Int, storefront: String)?

    init(result: Result<[MusicInfo], Error>) { self.result = result }

    func search(term: String, limit: Int, storefront: String) async throws -> [MusicInfo] {
        captured = (term, limit, storefront)
        return try result.get()
    }
}

struct StubStorefrontProvider: StorefrontProviding {
    let value: String
    func currentStorefront(forceRefresh: Bool) async throws -> String { value }
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

final class SearchViewModelTests: XCTestCase {

    @MainActor
    func test_search_success_updates_results_and_loadingStates() async {
        let musicId  = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let sourceId = UUID(uuidString: "00000000-0000-0000-0000-0000000000AA")!

        let music = Music(
            id: musicId,
            title: "Kanden",
            artist: "Yonezu Kenshi",
            artworkURL: nil,
            previewURL: nil
        )
        let source = MusicSource(
            musicId: musicId,
            musicVendor: .appleMusic,
            vendorTrackId: "1544491300",
            storefront: "kr",
            deeplinkURI: URL(string: "https://music.apple.com/kr/album/..."),
            artworkURLTemplate: nil,
            previewURL: nil,
            isrc: nil
        )

        let repo = StubRepo(result: .success([MusicInfo(music: music, source: source)]))
        let useCase = SearchMusicUseCase(
            repository: repo,
            storefrontProvider: StubStorefrontProvider(value: "kr")
        )
        let viewModel = SearchViewModel(
            searchMusic: useCase,
            imageLoader: StubImageLoader()
        )

        await viewModel.search(term: "Kanden", limit: 5)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.results.count, 1)

        XCTAssertEqual(viewModel.results.first?.music.title, "Kanden")
        XCTAssertEqual(viewModel.results.first?.music.artist, "Yonezu Kenshi")
        XCTAssertEqual(viewModel.results.first?.source.musicVendor, .appleMusic)

        XCTAssertEqual(repo.captured?.term, "Kanden")
        XCTAssertEqual(repo.captured?.limit, 5)
        XCTAssertEqual(repo.captured?.storefront, "kr")
    }

    @MainActor
    func test_search_failure_sets_errorMessage_and_stops_loading() async {
        let repo = StubRepo(result: .failure(DummyError()))
        let useCase = SearchMusicUseCase(
            repository: repo,
            storefrontProvider: StubStorefrontProvider(value: "kr")
        )
        let viewModel = SearchViewModel(
            searchMusic: useCase,
            imageLoader: StubImageLoader()
        )

        await viewModel.search(term: "Kanden", limit: 5)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.results.isEmpty)
    }
}
