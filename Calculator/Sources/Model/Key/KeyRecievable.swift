//
//  KeyRecievable.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/25.
//

import Foundation

// MARK: -
public protocol KeyRecievable {
    mutating func recieve(_ key: Key)
}

// MARK: -
public extension KeyRecievable where Self
: ClearKeyRecievable
& InversionKeyRecievable
& PercentKeyRecievable
& OperationKeyRecievable
& NumberKeyRecievable
& DotKeyRecievable
& EqualKeyRecievable
{
    mutating func recieve(_ key: Key) {
        switch key {
        case .clear(let value):
            recieve(value)
        case .inversion(let value):
            recieve(value)
        case .percent(let value):
            recieve(value)
        case .operation(let value):
            recieve(value)
        case .number(let value):
            recieve(value)
        case .dot(let value):
            recieve(value)
        case .equal(let value):
            recieve(value)
        }
    }
}

// MARK: -
public protocol ClearKeyRecievable {
    /// recieve `AC/C`
    mutating func recieve(_ value: Key.Clear)
}

// MARK: -
public protocol InversionKeyRecievable {
    /// recieve `+/-`
    mutating func recieve(_ value: Key.Inversion)
}

// MARK: -
public protocol PercentKeyRecievable {
    /// recieve `%`
    mutating func recieve(_ value: Key.Percent)
}

// MARK: -
public protocol OperationKeyRecievable {
    /// recieve operation
    mutating func recieve(_ value: Key.OperationName)
}

// MARK: -
public protocol NumberKeyRecievable {
    /// recieve bumber
    mutating func recieve(_ value: Key.Number)
}

// MARK: -
public protocol DotKeyRecievable {
    /// recieve `.`
    mutating func recieve(_ value: Key.Dot)
}

// MARK: -
public protocol EqualKeyRecievable {
    /// recieve `=`
    mutating func recieve(_ value: Key.Equal)
}
