//
//  OperandTests_Minus.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/08/01.
//

import XCTest
@testable import Calculator

class OperandTests_Minus: XCTestCase {
    func test_整数同士の減算の結果と出力() throws {
        let lhs = Operand(decimal: 0, fractionDigits: nil)
        let rhs = Operand(decimal: 0, fractionDigits: nil)
        let result = lhs - rhs
        XCTAssertEqual(Operand(), result)
        XCTAssertEqual("0", result.description)
    }

    func test_ドット付き整数の減算の結果と出力() throws {
        let lhs = Operand(decimal: 0, fractionDigits: 0)
        let rhs = Operand(decimal: 0, fractionDigits: 0)
        let result = lhs - rhs
        XCTAssertEqual(Operand(), result)
        XCTAssertEqual("0", result.description)
    }

    func test_ゼロ出力() throws {
        let lhs = Operand(decimal: 1.1, fractionDigits: 2)
        let rhs = Operand(decimal: 1.1, fractionDigits: 2)
        let result = BinaryOperators.minus(lhs, rhs)
        XCTAssertEqual("0", result.description)
    }

    func test_減算の結果は演算対象の小数位数の大きい方を優先する() throws {
        let operands = (
            Operand(decimal: 1.234, fractionDigits: 3),
            Operand(decimal: 1.1, fractionDigits: 1)
        )
        XCTContext.runActivity(named: "結果が正") { activity in
            let result = operands.0 - operands.1
            XCTAssertEqual(1.234 - 1.1, result.decimal)
            XCTAssertEqual(max(3, 1), result.fractionDigits)
            XCTAssertEqual("0.134", result.description)
        }
        XCTContext.runActivity(named: "結果が負") { _ in
            let result = operands.1 - operands.0
            XCTAssertEqual(1.1 - 1.234, result.decimal)
            XCTAssertEqual(max(1, 3), result.fractionDigits)
            XCTAssertEqual("-0.134", result.description)
        }
    }

    func test_減算の結果の小数を丸めて整数() throws {
        let operands = (
            Operand(decimal: 1.001, fractionDigits: 3),
            Operand(decimal: 0.001, fractionDigits: 3)
        )
        XCTContext.runActivity(named: "結果が正") { _ in
            let result = operands.0 - operands.1
            XCTAssertEqual(1, result.decimal)
            XCTAssertEqual(nil, result.fractionDigits)
            XCTAssertEqual("1", result.description)
        }
        XCTContext.runActivity(named: "結果が負") { _ in
            let result = operands.1 - operands.0
            XCTAssertEqual(-1, result.decimal)
            XCTAssertEqual(nil, result.fractionDigits)
            XCTAssertEqual("-1", result.description)
        }
    }

    func test_減算の結果の小数を丸めて小数() throws {
        let operands = (
            Operand(decimal: 0.901, fractionDigits: 2),
            Operand(decimal: 0.001, fractionDigits: 1)
        )
        XCTContext.runActivity(named: "結果が正") { _ in
            let result = operands.0 - operands.1
            XCTAssertEqual(0.9, result.decimal)
            XCTAssertEqual(1, result.fractionDigits)
            XCTAssertEqual("0.9", result.description)
        }
        XCTContext.runActivity(named: "結果が負") { _ in
            let result = operands.1 - operands.0
            XCTAssertEqual(-0.9, result.decimal)
            XCTAssertEqual(1, result.fractionDigits)
            XCTAssertEqual("-0.9", result.description)
        }
    }
}
