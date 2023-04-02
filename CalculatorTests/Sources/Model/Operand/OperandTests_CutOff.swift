//
//  OperandTests_CutOff.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/08/06.
//

import XCTest
@testable import Calculator

class OperandTests_CutOff: XCTestCase {
    func testExample() throws {
        let operand = Operand(decimal: 0, fractionDigits: nil)
        let result = operand.cutOff()
        XCTAssertEqual(result.decimal, 0)
        XCTAssertEqual(result.fractionDigits, nil)
        XCTAssertEqual(result.description, "0")
    }

    func testExample0() throws {
        let operand = Operand(decimal: 0, fractionDigits: 0)
        let result = operand.cutOff()
        XCTAssertEqual(0, result.decimal)
        XCTAssertEqual(nil, result.fractionDigits)
        XCTAssertEqual("0", result.description)
    }

    func testExample1() throws {
        let operand = Operand(decimal: 0, fractionDigits: 1)
        let result = operand.cutOff()
        XCTAssertEqual(0, result.decimal)
        XCTAssertEqual(nil, result.fractionDigits)
        XCTAssertEqual("0", result.description)
    }

    func testExample2() throws {
        let operand = Operand(decimal: 0.1230001, fractionDigits: 1)
        let result = operand.cutOff()
        XCTAssertEqual(0.1, result.decimal)
        XCTAssertEqual(1, result.fractionDigits)
        XCTAssertEqual("0.1", result.description)
    }

    func testExample3() throws {
        let operand = Operand(decimal: 0.1230001, fractionDigits: 7)
        let result = operand.cutOff()
        XCTAssertEqual(0.1230001, result.decimal)
        XCTAssertEqual(7, result.fractionDigits)
        XCTAssertEqual("0.1230001", result.description)
    }

    func testExample4() throws {
        let operand = Operand(decimal: 0.1230001, fractionDigits: 6)
        let result = operand.cutOff()
        XCTAssertEqual(0.123, result.decimal)
        XCTAssertEqual(3, result.fractionDigits)
        XCTAssertEqual("0.123", result.description)
    }

    func testExample5() throws {
        let operand = Operand(decimal: 0.1230001, fractionDigits: 99)
        let result = operand.cutOff()
        XCTAssertEqual(0.1230001, result.decimal)
        XCTAssertEqual(7, result.fractionDigits)
        XCTAssertEqual("0.1230001", result.description)
    }
}
