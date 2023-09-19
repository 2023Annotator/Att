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
        do {
            let searchResponse = try await MCatalog.search(for: named, types: [.songs], limit: 10)
            var info = searchResponse.songs.map { MusicInfo(title: $0.title, artist: $0.artistName, thumbnailImage: nil) }
            
            let artworks = searchResponse.songs.map { $0.artwork }
            
            var thumbnailImageList: [UIImage?] = []
            
            for artwork in artworks {
                guard let artworkURL = artwork?.url(width: 800, height: 800) else {
                    return nil
                }
                let (data, _) = try await URLSession.shared.data(from: artworkURL)
                thumbnailImageList.append(UIImage(data: data))
            }
            
            for idx in 0..<info.count {
                info[idx].setThumnailImage(as: thumbnailImageList[idx])
            }
            
            return info
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
