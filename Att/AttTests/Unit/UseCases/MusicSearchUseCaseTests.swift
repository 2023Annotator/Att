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
        private(set) var received: (term: String, limit: Int)?

        func setStub(_ values: [MusicInfo]) { _stub = values }
        func search(term: String, limit: Int) async throws -> [MusicInfo] {
            received = (term, limit)
            return _stub
        }
        func receivedParams() -> (String, Int)? { received.map { ($0.term, $0.limit) } }
    }
    
    func test_execute_callsRepository_andReturnsStub() async throws {
        let repo = MockRepo()
        await repo.setStub([MusicInfo(id: "id1", title: "Kanden", artist: "Yonezu Kenshi")])

        let sut = SearchMusicUseCase(repository: repo)
        let result = try await sut.execute(term: "Kanden", limit: 10)

        let received = await repo.receivedParams()
        XCTAssertEqual(received?.0, "Kanden")
        XCTAssertEqual(received?.1, 10)
        XCTAssertEqual(result.first?.id, "id1")
    }
}
