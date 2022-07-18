//
//  OperandTests_Multiply.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/08/01.
//

import XCTest
@testable import Calculator

class OperandTests_Multiply: XCTestCase {
    func test_整数同士の乗算の結果と出力() throws {
        let operand = Operand(decimal: 5, fractionDigits: nil)
        let result = operand * operand
        XCTAssertEqual(25, result.decimal)
        XCTAssertEqual(nil, result.fractionDigits)
        XCTAssertEqual("25", result.description)
    }

    func test_演算後に小数点を削除して表示() throws {
        let operand = Operand(decimal: 5, fractionDigits: 0)
        let result = operand * operand
        XCTAssertEqual(25, result.decimal)
        XCTAssertEqual(nil, result.fractionDigits)
        XCTAssertEqual("25", result.description)
    }

    func test_FractionDigitsLhs() throws {
        let lhs = Operand(decimal: 1.234, fractionDigits: 3)
        let rhs = Operand(decimal: 1.1, fractionDigits: 1)
        let result = lhs * rhs
        XCTAssertEqual(result.decimal, 1.3574)
        XCTAssertEqual(result.fractionDigits, 4)
        XCTAssertEqual(result.description, "1.3574")
    }

    func test_FractionDigitsRhs() throws {
        let lhs = Operand(decimal: 1.1, fractionDigits: 1)
        let rhs = Operand(decimal: 1.234, fractionDigits: 3)
        let result = lhs * rhs
        XCTAssertEqual(result.decimal, 1.3574)
        XCTAssertEqual(result.fractionDigits, 4)
        XCTAssertEqual(result.description, "1.3574")
    }

    func test_FractionDigitsShiftLhs() throws {
        let lhs = Operand(decimal: 0.999, fractionDigits: 3)
        let rhs = Operand(decimal: 0.001, fractionDigits: 3)
        let result = lhs * rhs
        XCTAssertEqual(result.decimal, 0.000999)
        XCTAssertEqual(result.fractionDigits, 6)
        XCTAssertEqual(result.description, "0.000999")
    }

    func test_FractionDigitsShiftRhs() throws {
        let lhs = Operand(decimal: 0.001, fractionDigits: 3)
        let rhs = Operand(decimal: 0.999, fractionDigits: 3)
        let result = lhs * rhs
        XCTAssertEqual(result.decimal, 0.000999)
        XCTAssertEqual(result.fractionDigits, 6)
        XCTAssertEqual(result.description, "0.000999")
    }

    func test_FractionDigitsShiftRhs2() throws {
        let lhs = Operand(decimal: 0.001, fractionDigits: 1) // 0.0
        let rhs = Operand(decimal: 0.899, fractionDigits: 2) // 0.89
        let result = lhs * rhs
        XCTAssertEqual(result.decimal, 0.0)
        XCTAssertEqual(result.fractionDigits, nil)
        XCTAssertEqual(result.description, "0")
    }
}
