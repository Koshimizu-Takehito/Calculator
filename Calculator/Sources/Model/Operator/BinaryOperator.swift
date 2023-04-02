//
//  BinaryOperator.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/24.
//

import Foundation

// MARK: - BinaryOperator
public protocol BinaryOperator {
    associatedtype X1 = Never
    associatedtype X2 = Never
    associatedtype Y = Never
    func callAsFunction(_ lhs: X1, _ rhs: X2) -> Y
}

public extension BinaryOperator {
    func callAsFunction(lhs: X1) -> AnyUnaryOperator<X2, Y> {
        AnyUnaryOperator { rhs in
            callAsFunction(lhs, rhs)
        }
    }

    func callAsFunction(rhs: X2) -> AnyUnaryOperator<X1, Y> {
        AnyUnaryOperator { lhs in
            callAsFunction(lhs, rhs)
        }
    }
}

public extension BinaryOperator where X1 == X2, X1 == Y {
    func callAsFunction(_ lhs: X1?, _ rhs: X1?) -> X1? {
        switch (lhs, rhs) {
        case let (lhs?, rhs?):
            return callAsFunction(lhs, rhs)
        default:
            return lhs ?? rhs
        }
    }
}

public extension BinaryOperator where X1 == Never, X2 == Never, Y == Never {
    func callAsFunction(_ lhs: Never, _ rhs: Never) -> Never {}
}

// MARK: - AnyBinaryOperator
@propertyWrapper
public struct AnyBinaryOperator<V1, V2, U>: BinaryOperator {
    public let wrappedValue: (V1, V2) -> U

    public init(wrappedValue: @escaping (V1, V2) -> U) {
        self.wrappedValue = wrappedValue
    }

    public init(_ value: @escaping (V1, V2) -> U) {
        self.init(wrappedValue: value)
    }

    public init<O>(_ o: O) where O: BinaryOperator, O.X1 == V1, O.X2 == V2, O.Y == U {
        self.init(wrappedValue: o.callAsFunction(_:_:))
    }

    public func callAsFunction(_ lhs: V1, _ rhs: V2) -> U {
        wrappedValue(lhs, rhs)
    }
}

// MARK: - BinaryOperators
public enum BinaryOperators: BinaryOperator {}

public extension BinaryOperators {
    static let identity = AnyBinaryOperator(Identity())
    static let plus = Plus()
    static let minus = Minus()
    static let multiply = Multiply()
    static let division = Division()

    static let operators: [Key.OperationName: AnyBinaryOperator] = [
        .identity: .init(identity),
        .plus: .init(plus),
        .minus: .init(minus),
        .multiply: .init(multiply),
        .division: .init(division)
    ]

    static subscript(_ key: Key.OperationName) -> AnyBinaryOperator<Operand, Operand, Operand>? {
        operators[key]
    }
}

public extension BinaryOperators {
    struct Identity: BinaryOperator {
        public func callAsFunction(_ lhs: Operand, _: Operand) -> Operand { lhs }
    }

    struct Plus: BinaryOperator {
        public func callAsFunction(_ lhs: Operand, _ rhs: Operand) -> Operand {
            let decimal = lhs.decimal + rhs.decimal
            let digits = AnyBinaryOperator(max)(lhs.fractionDigits, rhs.fractionDigits)
            let operand = Operand(decimal: decimal, fractionDigits: digits)
            if operand.decimal.isZero {
                // TODO: ゼロ以外にも任意の有効桁の丸めを実装する
                return Operand()
            }
            return UnaryOperators.roundDownZero(operand)
        }
    }

    struct Minus: BinaryOperator {
        public func callAsFunction(_ lhs: Operand, _ rhs: Operand) -> Operand {
            let decimal = lhs.decimal - rhs.decimal
            let digits = AnyBinaryOperator(max)(lhs.fractionDigits, rhs.fractionDigits)
            let operand = Operand(decimal: decimal, fractionDigits: digits)
            if operand.decimal.isZero {
                // TODO: ゼロ以外にも任意の有効桁の丸めを実装する
                return Operand()
            }
            return UnaryOperators.roundDownZero(operand)
        }
    }

    struct Multiply: BinaryOperator {
        public func callAsFunction(_ lhs: Operand, _ rhs: Operand) -> Operand {
            let decimal = lhs.decimal * rhs.decimal
            let digits = AnyBinaryOperator(+)(lhs.fractionDigits, rhs.fractionDigits)
            let operand = Operand(decimal: decimal, fractionDigits: digits)
            if operand.decimal.isZero {
                // TODO: ゼロ以外にも任意の有効桁の丸めを実装する
                return Operand()
            }
            return UnaryOperators.roundDownZero(operand)
        }
    }

    struct Division: BinaryOperator {
        public func callAsFunction(_ lhs: Operand, _ rhs: Operand) -> Operand {
            let decimal = lhs.decimal / rhs.decimal
            let operand = Operand(decimal: decimal, fractionDigits: FractionDigits(-decimal.exponent))
            if operand.decimal.isZero {
                // TODO: ゼロ以外にも任意の有効桁の丸めを実装する
                return Operand()
            }
            return UnaryOperators.roundDownZero(operand)
        }
    }
}
