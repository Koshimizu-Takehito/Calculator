//
//  FractionDigits.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/30.
//

import Foundation

// MARK: -
public struct FractionDigits: Hashable, RawRepresentable {
    /// non negative integer
    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        self.init(rawValue)
    }
}

public extension FractionDigits {
    var isZero: Bool {
        rawValue == 0
    }

    init?(_ value: Int) {
        switch value {
        case 0...:
            self.rawValue = value
        case _:
            return nil
        }
    }
}

// MARK: -
extension FractionDigits: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Optional: Comparable where Wrapped == FractionDigits {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        let lhs = lhs?.rawValue ?? .min
        let rhs = rhs?.rawValue ?? .min
        return lhs < rhs
    }
}

extension Optional: AdditiveArithmetic where Wrapped == FractionDigits {
    public static func - (lhs: Self, rhs: Self) -> Self {
        let lhs = lhs?.rawValue ?? 0
        let rhs = rhs?.rawValue ?? 0
        return FractionDigits(lhs - rhs)
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        let lhs = lhs?.rawValue ?? 0
        let rhs = rhs?.rawValue ?? 0
        return FractionDigits(lhs + rhs)
    }
}

extension Optional: ExpressibleByIntegerLiteral where Wrapped == FractionDigits {
    public init(integerLiteral value: Int) {
        self = FractionDigits(value)
    }
}
