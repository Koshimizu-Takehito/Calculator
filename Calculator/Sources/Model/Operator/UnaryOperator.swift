//
//  UnaryOperator.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/26.
//

import Foundation

// MARK: - BinaryOperator
public protocol UnaryOperator {
    associatedtype X = Never
    associatedtype Y = Never
    func callAsFunction(_ value: X) -> Y
}

public extension UnaryOperator {
    func callAsFunction(_ value: X?) -> Y? {
        value.map(callAsFunction)
    }
}

public extension UnaryOperator where X == Never, Y == Never {
    func callAsFunction(_ value: Never) -> Never {}
}

// MARK: - AnyUnaryOperator
@propertyWrapper
public struct AnyUnaryOperator<T, U>: UnaryOperator {
    public let wrappedValue: (T) -> U

    public init(wrappedValue: @escaping (T) -> U) {
        self.wrappedValue = wrappedValue
    }

    public func callAsFunction(_ value: T) -> U {
        wrappedValue(value)
    }
}

// MARK: -
public enum UnaryOperators: UnaryOperator {
    static let roundDownZero = RoundDownZero()

    struct RoundDownZero: UnaryOperator {
        func callAsFunction(_ value: Operand) -> Operand {
            switch value.fractionDigits {
            case .none:
                return Operand(decimal: value.decimal)

            case _? where FractionDigits(-value.decimal.exponent) == nil:
                return Operand(decimal: value.decimal)

            case let fractionDigits? where fractionDigits.isZero:
                return Operand(decimal: value.decimal)

            case let fractionDigits? where FractionDigits(-value.decimal.exponent) <= fractionDigits:
                let digits = -value.decimal.exponent
                if digits > 0 {
                    return Operand(decimal: value.decimal, fractionDigits: FractionDigits(digits))
                } else {
                    return Operand(decimal: value.decimal)
                }

            case let fractionDigits?: // where FractionDigits(value.decimal.exponent) > fractionDigits
                var shift = value.decimal * pow(10, fractionDigits.rawValue)
                var integer = Decimal()
                NSDecimalRound(&integer, &shift, 0, .plain)
                let digits = fractionDigits.rawValue - integer.exponent
                if digits > 0 {
                    return Operand(decimal: value.decimal, fractionDigits: FractionDigits(digits))
                } else {
                    return Operand(decimal: value.decimal)
                }
            }
        }
    }
}
