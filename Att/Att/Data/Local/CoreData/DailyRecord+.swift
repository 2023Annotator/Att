//
//  DailyRecord+.swift
//  Att
//
//  Created by 황정현 on 9/7/25.
//

import Foundation

extension DailyRecord {
    func toDomain() -> AttDailyRecord? {
        guard
            let moodRaw = moodReq,
            let mood = Mood(rawValue: moodRaw)
        else { return nil }
        
        let mappedMusic = trackReq?.toDomain()
        
        return AttDailyRecord(
            date: dateReq,
            mood: mood,
            music: mappedMusic,
            diary: diaryReq,
            phraseToTomorrow: phraseToTomorrow
        )
    }
    
    func update(as dailyRecord: AttDailyRecord) {
        self.date = dailyRecord.date
        self.diary = dailyRecord.diary
        self.mood = dailyRecord.mood?.rawValue
        self.phraseToTomorrow = dailyRecord.phraseToTomorrow
        
        if let info = dailyRecord.music {
            // 기존 관계가 있으면 갱신, 없으면 생성
            if let track = self.track {
                track.apply(from: info)
            } else {
                let track = Track(context: managedObjectContext!)
                track.apply(from: info)
                self.track = track
            }
        } else {
            self.track = nil
        }
    }
}

extension DailyRecord {
    public var idReq: UUID {
        get {
            guard let id = id else {
                preconditionFailure("DailyRecord.id must be set (or filled in awakeFromInsert)")
            }
            return id
        }
        set { id = newValue }
    }

    public var dateReq: Date {
        get {
            guard let date = date else {
                preconditionFailure("DailyRecord.date must be set (or filled in awakeFromInsert)")
            }
            return date
        }
        set { date = newValue }
    }

    public var diaryReq: String? {
        get { diary }
        set { diary = newValue }
    }

    public var moodReq: String? {
        get { mood }
        set { mood = newValue }
    }

    public var phraseToTomorrowReq: String? {
        get { phraseToTomorrow }
        set { phraseToTomorrow = newValue }
    }

    public var trackReq: Track? {
        get { track }
        set { track = newValue }
    }

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        if id == nil { id = UUID() }
        if date == nil { date = Date() }
    }
}
