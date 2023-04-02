//
//  InterfaceOrientationRecievable.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/14.
//

import UIKit

// MARK: -
public protocol InterfaceOrientationRecievable {
    mutating func recieve(orientation: InterfaceOrientation)
}
