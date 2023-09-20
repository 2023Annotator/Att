//
//  MusicInfo.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Foundation
import UIKit.UIImage

struct MusicInfo: Hashable {
    let title: String?
    let artist: String?
    var thumbnailImage: UIImage?
    
    static func == (lhs: MusicInfo, rhs: MusicInfo) -> Bool {
        return lhs.title == rhs.title && lhs.artist == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(artist)
    }
    
    mutating func setThumnailImage(as image: UIImage?) {
        self.thumbnailImage = image
    }
    
    func artistAndTitleStr() -> String {
        guard let artistStr = artist,
        let titleStr = title else { return "" }
        return "\(artistStr) - \(titleStr)"
    }
}
