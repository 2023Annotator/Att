//
//  MusicSearchUseCaseTests.swift
//  Att
//
//  Created by 황정현 on 8/12/25.
//

import XCTest
@testable import Att

final class MusicSearchUseCaseTests: XCTestCase {

    actor MockRepo: MusicSearchRepository {
        private var _stub: [MusicInfo] = []
        private(set) var received: (term: String, limit: Int, storefront: String)?

        func setStub(_ values: [MusicInfo]) { _stub = values }

        func search(term: String, limit: Int, storefront: String) async throws -> [MusicInfo] {
            received = (term, limit, storefront)
            return _stub
        }

        func receivedParams() -> (String, Int, String)? { received }
    }

    func test_execute_callsRepository_andReturnsStub() async throws {
        let repo = MockRepo()

        let musicId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
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
            isrc: "JPUM72000000"
        )

        await repo.setStub([MusicInfo(music: music, source: source)])

        let usecase = SearchMusicUseCase(repository: repo, storefrontProvider: MusicKitStorefrontProvider())
        let result = try await usecase.execute(term: "Kanden", limit: 10)

        let received = await repo.receivedParams()
        XCTAssertEqual(received?.0, "Kanden")
        XCTAssertEqual(received?.1, 10)
        XCTAssertEqual(received?.2, "kr")

        XCTAssertEqual(result.first?.music.id, musicId)
        XCTAssertEqual(result.first?.music.title, "Kanden")
        XCTAssertEqual(result.first?.music.artist, "Yonezu Kenshi")
        XCTAssertEqual(result.first?.source.musicVendor, .appleMusic)
        XCTAssertEqual(result.first?.source.vendorTrackId, "1544491300")
        XCTAssertEqual(result.first?.source.storefront, "kr")
    }
}
