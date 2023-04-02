//
//  OperandTests_Plus.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/31.
//

import XCTest
@testable import Calculator

class OperandTests_Plus: XCTestCase {
    func test_整数同士の加算の結果と出力() throws {
        let lhs = Operand(decimal: 0, fractionDigits: nil)
        let rhs = Operand(decimal: 0, fractionDigits: nil)
        let result = lhs + rhs
        XCTAssertEqual(Operand(), result)
        XCTAssertEqual("0", result.description)
    }

    func test_ドット付き整数の加算の結果と出力() throws {
        let lhs = Operand(decimal: 0, fractionDigits: 0)
        let rhs = Operand(decimal: 0, fractionDigits: 0)
        let result = lhs + rhs
        XCTAssertEqual(Operand(), result)
        XCTAssertEqual("0", result.description)
    }

    func test_加算の結果は演算対象の小数位数の大きい方を優先する() throws {
        let lhs = Operand(decimal: 1.234, fractionDigits: 3)
        let rhs = Operand(decimal: 1.1, fractionDigits: 1)
        let result = lhs + rhs
        XCTAssertEqual(2.334, result.decimal)
        XCTAssertEqual(3, result.fractionDigits)
        XCTAssertEqual("2.334", result.description)
    }

    func test_加算の結果が繰り上げ整数() throws {
        let lhs = Operand(decimal: 0.999, fractionDigits: 3)
        let rhs = Operand(decimal: 0.001, fractionDigits: 3)
        let result = lhs + rhs
        XCTAssertEqual(1, result.decimal)
        XCTAssertEqual(nil, result.fractionDigits)
        XCTAssertEqual("1", result.description)
    }

    func test_加算の結果が繰り上げ小数() throws {
        let lhs = Operand(decimal: 0.001, fractionDigits: 1)
        let rhs = Operand(decimal: 0.899, fractionDigits: 2)
        let result = lhs + rhs
        XCTAssertEqual(0.9, result.decimal)
        XCTAssertEqual(1, result.fractionDigits)
        XCTAssertEqual("0.9", result.description)
    }
}
