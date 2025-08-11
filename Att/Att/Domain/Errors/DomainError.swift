//
//  DomainError.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import Foundation

public enum DomainError: Error, Sendable {
    case invalidData
    case unauthorized
    case network
    case unknown
}
