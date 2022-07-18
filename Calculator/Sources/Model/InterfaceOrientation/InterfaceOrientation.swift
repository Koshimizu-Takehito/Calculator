//
//  InterfaceOrientation.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/14.
//

import UIKit

// MARK: -
public enum InterfaceOrientation: Int, Sendable {
    case unknown
    case portrait
    case portraitUpsideDown
    case landscapeRight
    case landscapeLeft
}

// MARK: -
public extension InterfaceOrientation {
    init(_ orientation: UIInterfaceOrientation) {
        self = Self.init(rawValue: orientation.rawValue) ?? .unknown
    }
}
