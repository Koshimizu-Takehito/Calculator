//
//  Calculator.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/24.
//

import Foundation

public struct Calculator {
    public struct UnaryOperator {
        let name: Key.OperationName?
        let operation: AnyUnaryOperator<Operand, Operand>
    }
    public struct BinaryOperator {
        let name: Key.OperationName?
        let operation: AnyBinaryOperator<Operand, Operand, Operand>
    }

    public private(set) var current: Operand
    private var previous: Operand?
    private var unaryOperator: UnaryOperator?
    private var binaryOperator: BinaryOperator?
    private var lastKey: Key?

    init(initial: Operand = .init(), operation: BinaryOperator? = nil) {
        self.current = initial
        self.binaryOperator = operation
        self.unaryOperator = operation.map { operation in
            UnaryOperator(
                name: operation.name,
                operation: operation.operation(rhs: initial)
            )
        }
    }
}

// MARK: - KeyRecievable
extension Calculator: KeyRecievable {
}

// MARK: - ClearKeyRecievable
extension Calculator: ClearKeyRecievable {
    public mutating func recieve(_ clear: Key.Clear) {
        if clear == .clear, binaryOperator != nil {
            // 演算子入力後、はじめて数字のゼロを入力した場合同じ
            if let previous = previous {
                current = previous
                self.previous = nil
            }
            recieve(._0)
            return
        }

        if clear == .allClear {
            unaryOperator = nil
        }
        current = .init()
        previous = nil
        binaryOperator = nil
        lastKey = .clear(clear)
    }
}

// MARK: - InversionKeyRecievable
extension Calculator: InversionKeyRecievable {
    public mutating func recieve(_ inversion: Key.Inversion) {
        current.recieve(inversion)
        lastKey = .inversion()
    }
}

// MARK: - PercentKeyRecievable
extension Calculator: PercentKeyRecievable {
    public mutating func recieve(_ percent: Key.Percent) {
        switch (previous, unaryOperator?.name) {
        case (.none, .none):
            // 100で割る（通常、期待するであろう計算）
            current.recieve(percent)

        case let (.none, operation?):
            let value = self.current
            switch operation {
            case .plus, .minus:
                // - 演算が和・差の場合は二乗してから100で割る
                self.current = BinaryOperators.multiply(value, value).recieved(percent)
            case .multiply, .division:
                // - 演算が積・商の場合は二乗せずに100で割る
                self.current = value.recieved(percent)
            case .identity:
                break
            }
            self.previous = value

        case let (previous?, .none):
            // 積をとってから100で割る
            current = BinaryOperators.multiply(previous, current)
                .recieved(percent)

        case let (previous?, operation?):
            switch operation {
            case .plus, .minus:
                // - 演算が和・差の場合は二乗してから100で割る
                self.current = BinaryOperators.multiply(previous, current).recieved(percent)
            case .multiply, .division:
                // - 演算が積・商の場合は二乗せずに100で割る
                self.current = current.recieved(percent)
            case .identity:
                break
            }
        }
        lastKey = .inversion()
    }
}

// MARK: - OperationKeyRecievable
extension Calculator: OperationKeyRecievable {
    public mutating func recieve(_ name: Key.OperationName) {
        switch previous {
        case .none:
            let operation = BinaryOperators.operators[name]
            self.binaryOperator = operation.map { operation in
                BinaryOperator(name: name, operation: operation)
            }
            self.unaryOperator = operation.map { binaryOperator in
                UnaryOperator(name: name, operation: binaryOperator(rhs: current))
            }
        case let previous?:
            // 前回の入力数値がある場合は計算する
            let binaryOperator = BinaryOperators.operators[name]!
            self.binaryOperator = .init(name: name, operation: binaryOperator)
            self.current = binaryOperator(previous, current)
            // 前回の入力数値の削除
            self.previous = nil
            // 計算結果で単項演算を作成
            self.unaryOperator = UnaryOperator(name: name, operation: binaryOperator(rhs: current))
        }
        lastKey = .operation(name)
    }
}

// MARK: - NumberKeyRecievable
extension Calculator: NumberKeyRecievable {
    public mutating func recieve(_ number: Key.Number) {
        switch (lastKey, binaryOperator, previous) {
        case (.equal, _, _):
            // イコールキーの入力後のインプットは、現在値を初期化する
            current = .init()
        case (_, .some, .none):
            previous = current
            current = Operand()
        case _:
            break
        }
        current.recieve(number)
        lastKey = .number(number)
    }
}

// MARK: - DotKeyRecievable
extension Calculator: DotKeyRecievable {
    public mutating func recieve(_ dot: Key.Dot) {
        switch lastKey {
        case .number, .dot:
            break
        case _:
            // 前回の入力が数字以外の場合は、先に数値0を入力した状態にする
            recieve(._0)
        }
        current.recieve(dot)
        lastKey = .dot()
    }
}

// MARK: - EqualKeyRecievable
extension Calculator: EqualKeyRecievable {
    public mutating func recieve(_ equal: Key.Equal) {
        switch (previous, binaryOperator, unaryOperator) {
        case let (previous?, binaryOperator?, _):
            let current = self.current
            // 二項演算が可能
            self.current = binaryOperator.operation(previous, current)
            // 単項演算を更新
            self.unaryOperator = UnaryOperator(
                name: binaryOperator.name,
                operation: binaryOperator.operation(rhs: current)
            )
            // イコールキー入力後の初期化
            self.previous = nil
            self.binaryOperator = nil

        case let (_, _, unaryOperator?):
            // 二項演算はできないが、単項演算が可能
            self.current = unaryOperator.operation(current)

        case _:
            // 二項演算も単項演算もできない
            var current = self.current
            current.recieve(equal)
            self.current = current
        }
        lastKey = .equal()
    }
}
