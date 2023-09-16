//
//  MusicInfo.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Foundation
import UIKit.UIImage

struct MusicInfo: Codable {
    let title: String
    let artist: String
    let thumbnailAddress: String
    
    var thumbnailImage: UIImage {
        guard let image = UIImage(named: thumbnailAddress) else { return UIImage() }
        return image
    }
    
    func artistAndTitleStr() -> String {
        return "\(artist) - \(title)"
    }
}
