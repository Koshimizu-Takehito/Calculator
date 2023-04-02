//
//  Key.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/24.
//

import Foundation

public enum Key: KeyProtocol {
    case clear(Clear)
    case inversion(Inversion = .inversion)
    case percent(Percent = .percent)
    case operation(OperationName)
    case number(Number)
    case dot(Dot = .dot)
    case equal(Equal = .equal)

    public init?(rawValue: String) {
        if let value = Clear(rawValue: rawValue) {
            self = .clear(value)
        } else if let value = OperationName(rawValue: rawValue) {
            self = .operation(value)
        } else if let value = Number(rawValue: rawValue) {
            self = .number(value)
        } else if let value = Inversion(rawValue: rawValue) {
            self = .inversion(value)
        } else if let value = Percent(rawValue: rawValue) {
            self = .percent(value)
        } else if let value = Dot(rawValue: rawValue) {
            self = .dot(value)
        } else if let value = Equal(rawValue: rawValue) {
            self = .equal(value)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .clear(let value):
            return value.rawValue
        case .inversion(let value):
            return value.rawValue
        case .percent(let value):
            return value.rawValue
        case .operation(let value):
            return value.rawValue
        case .number(let value):
            return value.rawValue
        case .dot(let value):
            return value.rawValue
        case .equal(let value):
            return value.rawValue
        }
    }
}

public extension Key {
    enum Clear: String, KeyProtocol {
        case allClear = "AC"
        case clear = "C"
    }

    enum Number: String, KeyProtocol {
        case _0 = "0"
        case _1 = "1"
        case _2 = "2"
        case _3 = "3"
        case _4 = "4"
        case _5 = "5"
        case _6 = "6"
        case _7 = "7"
        case _8 = "8"
        case _9 = "9"
    }

    enum OperationName: String, KeyProtocol {
        case identity = ""
        case plus = "＋"
        case minus = "−"
        case multiply = "×"
        case division = "÷"
    }

    enum Inversion: String, KeyProtocol {
        case inversion = "+/-"
    }

    enum Percent: String, KeyProtocol {
        case percent = "%"
    }

    enum Dot: String, KeyProtocol {
        case dot = "."
    }

    enum Equal: String, KeyProtocol {
        case equal = "＝"
    }
}

public protocol KeyProtocol: RawRepresentable, Hashable, Identifiable {
    associatedtype RawValue = String
}

public extension KeyProtocol where RawValue == String {
    var id: String { rawValue }
}

