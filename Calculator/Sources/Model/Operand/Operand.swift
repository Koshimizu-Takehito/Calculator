//
//  Operand.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/24.
//

import Foundation

// MARK: - Operand
public struct Operand: Hashable {
    public private(set) var decimal: Decimal
    public private(set) var fractionDigits: FractionDigits?

    public init(decimal: Decimal = 0, fractionDigits: FractionDigits? = nil) {
        var _decimal = decimal, rounded = Decimal()
        NSDecimalRound(&rounded, &_decimal, fractionDigits?.rawValue ?? 0, .plain)

        self.decimal = rounded
        self.fractionDigits = fractionDigits
    }
}

// MARK: - UnaryOperators
public extension Operand {
    func cutOff() -> Self {
        UnaryOperators.roundDownZero(self)
    }
}

// MARK: - ClearKeyRecievable
extension Operand: ClearKeyRecievable {
    mutating public func recieve(_ value: Key.Clear) {
        decimal = 0
        fractionDigits = nil
    }
}

// MARK: - InversionKeyRecievable
extension Operand: InversionKeyRecievable {
    mutating public func recieve(_ value: Key.Inversion) {
        decimal *= -1
    }
}

// MARK: - PercentKeyRecievable
extension Operand: PercentKeyRecievable {
    mutating public func recieve(_ value: Key.Percent) {
        decimal /= 100
        fractionDigits = fractionDigits.map { $0 + 2 } ?? 2
        self = UnaryOperators.roundDownZero(self)
    }

    public func recieved(_ value: Key.Percent) -> Self {
        var copy = self
        copy.recieve(value)
        return copy
    }
}

// MARK: - NumberKeyRecievable
extension Operand: NumberKeyRecievable {
    mutating public func recieve(_ value: Key.Number) {
        let value = Decimal(string: value.rawValue)!
        switch fractionDigits {
        case .none:
            var _decimal = decimal, rounded = Decimal()
            NSDecimalRound(&rounded, &_decimal, 0, .plain)
            let sign: Decimal = (rounded.sign == .plus) ? 1 : -1
            decimal = 10 * rounded + sign * value
        case let digits?:
            var _decimal = decimal, rounded = Decimal()
            NSDecimalRound(&rounded, &_decimal, digits.rawValue, .plain)
            let sign: Decimal = (rounded.sign == .plus) ? 1 : -1
            let next = digits.rawValue + 1
            decimal = rounded + sign * value / pow(10, Int(next))
            fractionDigits = FractionDigits(next)
        }
    }
}

// MARK: - DotKeyRecievable
extension Operand: DotKeyRecievable {
    mutating public func recieve(_ value: Key.Dot) {
        if fractionDigits == nil {
            fractionDigits = 0
        }
    }
}

// MARK: - EqualKeyRecievable
extension Operand: EqualKeyRecievable {
    mutating public func recieve(_ value: Key.Equal) {
        let rounded = UnaryOperators.roundDownZero(self)
        self = Operand(decimal: rounded.decimal, fractionDigits: rounded.fractionDigits)
    }
}

// MARK: - CustomStringConvertible
extension Operand: CustomStringConvertible {
    public var description: String {
        let maximumFractionDigits = 8
        var _decimal = decimal, rounded = Decimal()
        NSDecimalRound(&rounded, &_decimal, maximumFractionDigits, .plain)

        let digits = min(fractionDigits?.rawValue ?? 0, maximumFractionDigits)
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        guard var string = formatter.string(from: rounded as NSNumber) else {
            return Decimal.nan.description
        }
        if fractionDigits == 0 {
            string += "."
        }
        return string
    }
}

// MARK: - BinaryOperators
extension Operand: AdditiveArithmetic {
    static public let zero = Self.init()

    static public func +(_ lhs: Self, _ rhs: Self) -> Self {
        BinaryOperators.plus(lhs, rhs)
    }

    static public func -(_ lhs: Self, _ rhs: Self) -> Self {
        BinaryOperators.minus(lhs, rhs)
    }
}

public extension Operand {
    static func *(_ lhs: Self, _ rhs: Self) -> Self {
        BinaryOperators.multiply(lhs, rhs)
    }

    static func /(_ lhs: Self, _ rhs: Self) -> Self {
        BinaryOperators.division(lhs, rhs)
    }
}

public extension Operand {
    static func notZero() -> Self {
        let value = Double.random(in: Double.leastNormalMagnitude...Double.greatestFiniteMagnitude)
        if value.isZero {
            return notZero()
        }
        let digits = Int.random(in: Int.min...Int.max)
        if digits == 0 {
            return notZero()
        }
        return Operand(decimal: .init(value), fractionDigits: .init(rawValue: digits))
    }
}

// MARK: -
private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumIntegerDigits = 30
    formatter.minimumIntegerDigits = 1
    return formatter
}()
