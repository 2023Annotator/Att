//
//  MusicAuthorizationManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Combine
import MusicKit

enum MusicKitError: Error {
    case restricted
    case notDetermined
    case denied
}

final class MusicAuthorizationManager {
    static let shared = MusicAuthorizationManager()
    
    @Published var isAuthorizedForMusicKit = false
    @Published var musicKitError: MusicKitError?

    func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request()

        switch status {
        case .authorized:
            isAuthorizedForMusicKit = true
        case .restricted:
            musicKitError = .restricted
        case .notDetermined:
            musicKitError = .notDetermined
        case .denied:
            musicKitError = .denied
        @unknown default:
            musicKitError = .notDetermined
        }
    }
}
