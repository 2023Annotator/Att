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
    
    let sourceUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
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
    
    private func makeMusic(title: String = "Title title", artist: String = "Artist Name") -> Music {
        Music(title: title, artist: artist, artworkURL: nil, previewURL: nil)
    }
    
    private func makeSource(vendor: MusicVendor = MusicVendor.appleMusic,
                            vendorTrackId: String = "APL-001",
                            isrc: String? = nil) -> MusicSource {
        MusicSource(musicId: sourceUUID, musicVendor: vendor, vendorTrackId: vendorTrackId, storefront: "kr", isrc: isrc)
    }

    private func sampleDaily(date: Date = Date(),
                             music: Music? = nil,
                             musicSource: MusicSource? = nil) -> AttDailyRecord {
        AttDailyRecord(
            date: date,
            mood: .joy,
            music: music ?? makeMusic(),
            musicSource: musicSource,
            diary: "nice day",
            phraseToTomorrow: "don't be anxiety"
        )
    }
    
    func test_insert_creates_new_track_and_tracksource_when_no_candidate_matches() throws {
        let sourceInfo = makeSource(vendor: .appleMusic, vendorTrackId: "APL-NEW-123", isrc: "ISRC-NEW-123")
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "BrandNew", artist: "NewArtist"),
                        musicSource: sourceInfo))

        let context = stack.container.viewContext

        let tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)

        let sources = try context.fetch(TrackSource.fetchRequest())
        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(sources.first?.track?.objectID, tracks.first?.objectID) // 링크 확인

        // Track.id가 생성되었는지(갱신 아님)
        XCTAssertNotNil(tracks.first?.id)
    }

    func test_reuse_by_vendor_pair_preserves_track_id_and_reuses_tracksource() throws {
        let sourceV1 = makeSource(vendor: .appleMusic, vendorTrackId: "APL-123", isrc: "ISRC-X")
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo", artist: "Bar"),
                        musicSource: sourceV1))

        let context = stack.container.viewContext
        var tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)
        let firstTrack = tracks.first!
        let firstTrackUUID = firstTrack.id
        let firstTrackOID  = firstTrack.objectID

        // 같은 vendor+vendorTrackId, 메타만 변경
        let sourceV2 = makeSource(vendor: .appleMusic, vendorTrackId: "APL-123", isrc: "ISRC-X")
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo (Edited)", artist: "Bar"),
                        musicSource: sourceV2))

        tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)
        XCTAssertEqual(tracks.first?.objectID, firstTrackOID)
        XCTAssertEqual(tracks.first?.id, firstTrackUUID)

        let sources = try context.fetch(TrackSource.fetchRequest())
        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(sources.first?.track?.objectID, firstTrackOID)
    }

    func test_reuse_by_isrc_and_same_title_across_vendors_preserves_track_id_and_adds_source() throws {
        let isrcCode = "USUM71705355"

        // 1st: Apple
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo", artist: "Bar"),
                        musicSource: makeSource(vendor: .appleMusic, vendorTrackId: "APL-1", isrc: isrcCode)))

        let context = stack.container.viewContext
        var tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)
        let firstTrack = tracks.first!
        let firstTrackUUID = firstTrack.id
        let firstTrackOID  = firstTrack.objectID

        // 2nd: Spotify (같은 ISRC + 같은 제목/아티스트)
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo", artist: "Bar"),
                        musicSource: makeSource(vendor: .spotifyMusic, vendorTrackId: "SPOT-9", isrc: isrcCode)))

        tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)
        XCTAssertEqual(tracks.first?.objectID, firstTrackOID)
        XCTAssertEqual(tracks.first?.id, firstTrackUUID)

        let sources = try context.fetch(TrackSource.fetchRequest())
        XCTAssertEqual(sources.count, 2)                             // 벤더 전환으로 소스 2개
        XCTAssertEqual(Set(sources.compactMap { $0.track?.objectID }), [firstTrackOID])
    }

    func test_createDailyRecord_fallback_match_by_title_artist_when_id_diff() throws {
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Same", artist: "Artist")))
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Same", artist: "Artist")))
        
        let context = stack.container.viewContext
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        let tracks = try context.fetch(fetchRequest)
        XCTAssertEqual(tracks.count, 1)
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

        let recordV1 = AttDailyRecord(
            date: day,
            mood: .joy,
            music: makeMusic(title: "T1", artist: "AR1"),
            diary: "v1",
            phraseToTomorrow: "p1"
        )
        sut.createDailyRecord(dailyRecord: recordV1)

        let recordV2 = AttDailyRecord(
            date: day,
            mood: .anger,
            music: makeMusic(title: "T2", artist: "AR2"),
            diary: "v2",
            phraseToTomorrow: "p2"
        )
        sut.createDailyRecord(dailyRecord: recordV2)

        let list = sut.fetchDailyRecords(startDate: day, endDate: day) ?? []
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.diary, "v2")
        XCTAssertEqual(list.first?.mood, .anger)
    }
    
    func test_createDailyRecord_reuses_existing_track_when_same_vendor_pair() throws {
        // 동일 vendor + vendorTrackId 이면 같은 Track으로
        let sourceInfo = makeSource(vendor: MusicVendor.appleMusic, vendorTrackId: "APL-123")

        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "A", artist: "AR"), musicSource: sourceInfo))
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "B", artist: "BR"), musicSource: sourceInfo))

        let context = stack.container.viewContext
        let tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)
    }

    func test_reuses_track_by_isrc_and_same_title_across_different_vendors() throws {
        // ISRC 같고 제목/아티스트도 같으면 → 벤더 달라도 같은 Track, TrackSource는 2개
        let isrcCode = "USUM71705355"

        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo", artist: "Bar"),
                        musicSource: makeSource(vendor: MusicVendor.appleMusic, vendorTrackId: "APL-1", isrc: isrcCode)))

        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo", artist: "Bar"),
                        musicSource: makeSource(vendor: MusicVendor.spotifyMusic, vendorTrackId: "SPOT-9", isrc: isrcCode)))

        let context = stack.container.viewContext
        let trackFetch: NSFetchRequest<Track> = Track.fetchRequest()
        let tracks = try context.fetch(trackFetch)
        XCTAssertEqual(tracks.count, 1, "동일 ISRC + 동일 제목/아티스트면 같은 Track이어야 함")

        let sourceFetch: NSFetchRequest<TrackSource> = TrackSource.fetchRequest()
        let sources = try context.fetch(sourceFetch)
        XCTAssertEqual(sources.count, 2, "벤더 전환 시 TrackSource는 벤더마다 추가되어 총 2개여야 함")
        XCTAssertEqual(Set(sources.compactMap { $0.track?.objectID }),
                       [tracks.first!.objectID],
                       "두 TrackSource가 같은 Track을 가리켜야 함")
    }

    func test_does_not_merge_different_version_even_if_isrc_matches() throws {
        // ISRC 같아도 제목이 다르면(예: Remaster) → 다른 Track으로
        let isrcCode = "USUM71705355"

        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic( title: "Foo", artist: "Bar"),
                        musicSource: makeSource(vendor: MusicVendor.appleMusic, vendorTrackId: "APL-1", isrc: isrcCode)))

        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "Foo (Remaster)", artist: "Bar"),
                        musicSource: makeSource(vendor: MusicVendor.spotifyMusic, vendorTrackId: "SPOT-9", isrc: isrcCode)))

        let context = stack.container.viewContext
        let trackFetch: NSFetchRequest<Track> = Track.fetchRequest()
        let tracks = try context.fetch(trackFetch)
        XCTAssertEqual(tracks.count, 2, "리마스터 표기가 있는 경우는 별도 Track으로 남아야 함")
    }

    func test_reuses_track_by_title_artist_when_no_isrc_and_vendor_changes() throws {
        // ISRC가 없고 벤더만 달라졌지만, 제목/아티스트가 같으면 → 같은 Track, TrackSource는 2개
        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "SameTitle", artist: "SameArtist"),
                        musicSource: makeSource(vendor: MusicVendor.appleMusic, vendorTrackId: "APL-77", isrc: nil)))

        sut.createDailyRecord(dailyRecord:
            sampleDaily(music: makeMusic(title: "SameTitle", artist: "SameArtist"),
                        musicSource: makeSource(vendor: MusicVendor.spotifyMusic, vendorTrackId: "SPOT-88", isrc: nil)))

        let context = stack.container.viewContext
        let trackFetch: NSFetchRequest<Track> = Track.fetchRequest()
        let tracks = try context.fetch(trackFetch)
        XCTAssertEqual(tracks.count, 1, "ISRC가 없어도 title+artist 같으면 같은 Track이어야 함")

        let sourceFetch: NSFetchRequest<TrackSource> = TrackSource.fetchRequest()
        let sources = try context.fetch(sourceFetch)
        XCTAssertEqual(sources.count, 2, "벤더 전환에 따라 TrackSource는 2개여야 함")
        XCTAssertEqual(Set(sources.compactMap { $0.track?.objectID }),
                       [tracks.first!.objectID],
                       "두 TrackSource가 같은 Track을 가리켜야 함")
    }
    
    func test_delete_one_of_two_dailyrecords_keeps_shared_track_and_source() throws {
        // 준비: 같은 (vendor, vendorTrackId) → 같은 Track/TrackSource 재사용
        let sharedSource = makeSource(vendor: .appleMusic, vendorTrackId: "APL-SHARED", isrc: "ISRC-SHARED")
        let dayOne = Date(timeIntervalSince1970: 1_800_000_000)
        let dayTwo = Date(timeIntervalSince1970: 1_800_086_400) // +1 day

        sut.createDailyRecord(
            dailyRecord: sampleDaily(date: dayOne,
                                     music: makeMusic(title: "SameTitle", artist: "SameArtist"),
                                     musicSource: sharedSource)
        )
        sut.createDailyRecord(
            dailyRecord: sampleDaily(date: dayTwo,
                                     music: makeMusic(title: "SameTitle", artist: "SameArtist"),
                                     musicSource: sharedSource)
        )

        let context = stack.container.viewContext
        // 생성 검증
        XCTAssertEqual(sut.fetchAllDailyRecords()?.count, 2)

        var tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1)
        let sharedTrackObjectID = tracks.first!.objectID

        var sources = try context.fetch(TrackSource.fetchRequest())
        XCTAssertEqual(sources.count, 1)
        XCTAssertEqual(sources.first?.track?.objectID, sharedTrackObjectID)

        // 액션: 일자 1개만 삭제
        sut.deleteDailyRecord(dailyRecord: sampleDaily(date: dayOne))

        // 검증: DailyRecord는 1개 남고, 공유 Track/TrackSource는 그대로 유지되어야 함
        XCTAssertEqual(sut.fetchAllDailyRecords()?.count, 1)

        tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1, "하나만 삭제해도 공유 Track은 삭제되면 안 됨")

        sources = try context.fetch(TrackSource.fetchRequest())
        XCTAssertEqual(sources.count, 1, "하나만 삭제해도 공유 TrackSource는 삭제되면 안 됨")
        XCTAssertEqual(sources.first?.track?.objectID, sharedTrackObjectID)
    }

    func test_delete_all_dailyrecords_does_not_delete_track_or_source_by_default() throws {
        // 준비: 같은 트랙/소스를 가리키는 두 개의 일기
        let sharedSource = makeSource(vendor: .appleMusic, vendorTrackId: "APL-SOLO", isrc: "ISRC-SOLO")
        let dayOne = Date(timeIntervalSince1970: 1_900_000_000)
        let dayTwo = Date(timeIntervalSince1970: 1_900_086_400)

        sut.createDailyRecord(
            dailyRecord: sampleDaily(date: dayOne,
                                     music: makeMusic(title: "Solo", artist: "Artist"),
                                     musicSource: sharedSource)
        )
        sut.createDailyRecord(
            dailyRecord: sampleDaily(date: dayTwo,
                                     music: makeMusic(title: "Solo", artist: "Artist"),
                                     musicSource: sharedSource)
        )

        let context = stack.container.viewContext
        XCTAssertEqual(sut.fetchAllDailyRecords()?.count, 2)

        // 액션: 두 레코드 모두 삭제
        sut.deleteDailyRecord(dailyRecord: sampleDaily(date: dayOne))
        sut.deleteDailyRecord(dailyRecord: sampleDaily(date: dayTwo))

        // 검증: DailyRecord는 0, Track/TrackSource는 남아 있음
        XCTAssertEqual(sut.fetchAllDailyRecords()?.count, 0)

        let tracks = try context.fetch(Track.fetchRequest())
        XCTAssertEqual(tracks.count, 1, "모든 DailyRecord가 없어져도 Track은 남아야 함 - 추후 배치 처리")

        let sources = try context.fetch(TrackSource.fetchRequest())
        XCTAssertEqual(sources.count, 1, "모든 DailyRecord가 없어져도 TrackSource는 남아야 함 - 추후 배치 처리")
        XCTAssertEqual(sources.first?.track?.objectID, tracks.first?.objectID)
    }

}
