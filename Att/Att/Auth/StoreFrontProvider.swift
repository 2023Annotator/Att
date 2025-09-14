//
//  StoreFrontProvider.swift
//  Att
//
//  Created by 황정현 on 9/14/25.
//

public protocol StorefrontProviding: Sendable {
    func currentStorefront(forceRefresh: Bool) async throws -> String
}

public struct MusicKitStorefrontProvider: StorefrontProviding {
    public init() {}
    public func currentStorefront(forceRefresh: Bool = false) async throws -> String {
        try await MusicAuthorizationManager.shared.ensureStorefront(forceRefresh: forceRefresh)
    }
}
