//
//  RecordCreationViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Foundation

final class RecordCreationViewModel {
    @Published var musicInfo: MusicInfo?
    
    func setMusicInfo(musicInfo: MusicInfo?) {
        self.musicInfo = musicInfo
    }
}
