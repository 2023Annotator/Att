//
//  MusicManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Combine
import UIKit.UIImage
import MusadoraKit
import MediaPlayer

final class MusicManager {
    let musicPlayer: MPMusicPlayerController?
    let musicID: MusicItemID?
    
    init() {
        musicPlayer = nil
        musicID = nil
    }
    
    init(musicID: String?) {
        musicPlayer = MPMusicPlayerController.applicationMusicPlayer
        
        if let musicID = musicID {
            self.musicID = MusicItemID(musicID)
        } else {
            self.musicID = nil
        }
    }
    
    func getMusicList(named: String) async -> [MusicInfo]? {
        var musicInfoList: [MusicInfo] = []
        
        do {
            let searchResponse = try await MCatalog.search(for: named, types: [.songs], limit: 10)
            for song in searchResponse.songs {
                let thumbnailImage = await getArtworkUIImage(artwork: song.artwork)
                let musicInfo = MusicInfo(id: song.id.rawValue, title: song.title, artist: song.artistName, thumbnailImage: thumbnailImage)
                musicInfoList.append(musicInfo)
            }
            return musicInfoList
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func getArtworkUIImage(artwork: Artwork?) async -> UIImage? {
        do {
            guard let artworkURL = artwork?.url(width: 800, height: 800) else { return nil }
            
            let (data, _) = try await URLSession.shared.data(from: artworkURL)
            return UIImage(data: data)
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func play() {
        Task {
            do {
                guard let musicID = musicID else { return }
                let searchResponse = try await MCatalog.song(id: musicID)
                musicPlayer?.setQueue(with: [searchResponse.id.rawValue])
                musicPlayer?.play()
            } catch {
                print("Error playing the song: \(error.localizedDescription)")
            }
        }
    }
    
    func stop() {
        musicPlayer?.stop()
    }
}
