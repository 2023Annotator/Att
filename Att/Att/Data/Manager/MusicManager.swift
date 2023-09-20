//
//  MusicManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Combine
import UIKit.UIImage
import MusadoraKit

final class MusicManager {
    func getMusicList(named: String) async -> [MusicInfo]? {
        var musicInfoList: [MusicInfo] = []
        
        do {
            let searchResponse = try await MCatalog.search(for: named, types: [.songs], limit: 10)
            for song in searchResponse.songs {
                let thumbnailImage = await getArtworkUIImage(artwork: song.artwork)
                let musicInfo = MusicInfo(title: song.title, artist: song.artistName, thumbnailImage: thumbnailImage)
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
}
