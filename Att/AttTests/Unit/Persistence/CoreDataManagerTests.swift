//
//  CoreDataManagerTests.swift
//  Att
//
//  Created by 황정현 on 8/12/25.
//

import XCTest
import CoreData
@testable import Att

final class CoreDataManagerTests: XCTestCase {
    
    var stack: TestCoreDataStack!
    var sut: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        stack = TestCoreDataStack()
        sut = CoreDataManager(testContainer: stack.container)
    }
    
    override func tearDown() {
        sut.deleteAllDailyRecord()
        sut = nil
        stack = nil
        super.tearDown()
    }
    
    private func sampleDaily(date: Date = Date(),
                             music: MusicInfo? = MusicInfo(id: "song_1",
                                                           title: "Title title",
                                                           artist: "Artist Name")) -> AttDailyRecord {
        AttDailyRecord(
            date: date,
            mood: .joy,
            musicInfo: music,
            diary: "nice day",
            phraseToTomorrow: "don't be anxiety"
        )
    }
    
    func test_createDailyRecord_inserts_and_links_music_by_id() {
        sut.createDailyRecord(dailyRecord: sampleDaily())
        
        let all = sut.fetchAllDailyRecords() ?? []
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.musicInfo?.id, "song_1")
        
        let ctx = stack.container.viewContext
        let req: NSFetchRequest<Music> = Music.fetchRequest()
        let musics = try? ctx.fetch(req)
        XCTAssertEqual(musics?.count, 1)
        XCTAssertEqual(musics?.first?.id, "song_1")
    }
    
    func test_createDailyRecord_reuses_existing_music_when_same_id() {
        sut.createDailyRecord(dailyRecord: sampleDaily())
        sut.createDailyRecord(dailyRecord: sampleDaily())
        
        let ctx = stack.container.viewContext
        let req: NSFetchRequest<Music> = Music.fetchRequest()
        let musics = try? ctx.fetch(req)
        XCTAssertEqual(musics?.count, 1) // 같은 id → 1개
    }
    
    func test_createDailyRecord_fallback_match_by_title_artist_when_id_diff() {
        sut.createDailyRecord(dailyRecord:
                                sampleDaily(music: MusicInfo(id: "A", title: "Same", artist: "Artist", artworkURL: nil))
        )
        sut.createDailyRecord(dailyRecord:
                                sampleDaily(music: MusicInfo(id: "B", title: "Same", artist: "Artist", artworkURL: nil))
        )
        
        let ctx = stack.container.viewContext
        let req: NSFetchRequest<Music> = Music.fetchRequest()
        let musics = try? ctx.fetch(req)
        XCTAssertEqual(musics?.count, 1) // title+artist 폴백 매칭 성공
    }
    
    func test_updateDailyRecord_updates_fields() {
        let day = Date()
        sut.createDailyRecord(dailyRecord: sampleDaily(date: day))
        
        var updated = sampleDaily(date: day)
        updated.diary = "changed"
        sut.updateDailyRecord(dailyRecord: updated)
        
        let fetched = sut.fetchDailyRecords(startDate: day, endDate: day)?.first
        XCTAssertEqual(fetched?.diary, "changed")
    }
    
    func test_deleteDailyRecord_removes_row() {
        let day = Date()
        sut.createDailyRecord(dailyRecord: sampleDaily(date: day))
        XCTAssertEqual(sut.fetchAllDailyRecords()?.count, 1)
        
        sut.deleteDailyRecord(dailyRecord: sampleDaily(date: day))
        XCTAssertEqual(sut.fetchAllDailyRecords()?.count, 0)
    }
    
    func test_upsert_sameDate_createsOnce_andUpdatesFields() {
        let day = Date(timeIntervalSince1970: 1_725_000_000)

        let rec1 = AttDailyRecord(
            date: day,
            mood: .joy,
            musicInfo: MusicInfo(id: "A", title: "T1", artist: "AR1", artworkURL: nil), diary: "v1",
            phraseToTomorrow: "p1"
        )
        sut.createDailyRecord(dailyRecord: rec1)

        let rec2 = AttDailyRecord(
            date: day,
            mood: .anger,
            musicInfo: MusicInfo(id: "B", title: "T2", artist: "AR2", artworkURL: nil), diary: "v2",
            phraseToTomorrow: "p2"
        )
        sut.createDailyRecord(dailyRecord: rec2)

        let list = sut.fetchDailyRecords(startDate: day, endDate: day) ?? []
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.diary, "v2")
        XCTAssertEqual(list.first?.mood, .anger)
        XCTAssertEqual(list.first?.musicInfo?.id, "B")
    }
}
