//
//  MusicAuthorizationManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Combine
import MusicKit

@MainActor
final class MusicAuthorizationManager: ObservableObject {
    static let shared = MusicAuthorizationManager()

    @Published private(set) var status: MusicAuthorization.Status = .notDetermined
    var isAuthorized: Bool { status == .authorized }

    func refreshStatus() {
        status = MusicAuthorization.currentStatus
    }

    /// 필요할 때만 요청(이미 결정된 상태면 요청 안 함)
    @discardableResult
    func requestIfNeeded() async -> MusicAuthorization.Status {
        let current = MusicAuthorization.currentStatus
        if current == .notDetermined {
            let newStatus = await MusicAuthorization.request()
            status = newStatus
            return newStatus
        } else {
            status = current
            return current
        }
    }

    func ensureAuthorized() async throws {
        let status = await requestIfNeeded()
        switch status {
        case .authorized:
            return
        case .denied, .restricted:
            throw DomainError.unauthorized
        case .notDetermined:
            throw DomainError.unknown
        @unknown default:
            throw DomainError.unknown
        }
    }
}
