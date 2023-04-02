//
//  CalculatorDisplay.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/14.
//

import Foundation

// MARK: -
public struct CalculatorDisplay {
    private var operand: Operand
    private var orientation: InterfaceOrientation

    public init(operand: Operand, orientation: InterfaceOrientation = .unknown) {
        self.operand = operand
        self.orientation = orientation
    }
}

// MARK: -
public extension CalculatorDisplay {
    mutating func recieve(operand: Operand) {
        self.operand = operand
    }
}

// MARK: - InterfaceOrientationRecievable
extension CalculatorDisplay: InterfaceOrientationRecievable {
    mutating public func recieve(orientation: InterfaceOrientation) {
        self.orientation = orientation
    }
}

// MARK: - CustomStringConvertible
extension CalculatorDisplay: CustomStringConvertible {
    public var description: String {
        Self.output(operand, orientation)
    }
}

// MARK: -
private extension CalculatorDisplay {
    static func output(_ operand: Operand, _ orientation: InterfaceOrientation) -> String {
        // TODO: レイアウトに合わせて最大表示桁を整形する
        return operand.description
    }
}
