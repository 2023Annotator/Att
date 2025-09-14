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
    @Published private(set) var storefront: String?
    var isAuthorized: Bool { status == .authorized }

    func refreshStatus() {
        status = MusicAuthorization.currentStatus
    }

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

    func ensureStorefront(forceRefresh: Bool = false) async throws -> String {
        if let storefront = storefront, !forceRefresh { return storefront }
        try await ensureAuthorized()
        let code = try await MusicDataRequest.currentCountryCode   // 예: "KR"
        let normalized = code.lowercased()
        storefront = normalized
        return normalized
    }

    /// 권한이 없는 상태에서 UI 진입 시, 미리 스토어프론트를 시도 조회하고 싶다면 호출
    func refreshStorefrontIfAuthorized() async {
        guard isAuthorized else {
            storefront = nil
            return
        }
        do {
            let code = try await MusicDataRequest.currentCountryCode
            storefront = code.lowercased()
        } catch {
            storefront = nil
        }
    }
}
