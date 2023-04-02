//
//  OperandTests.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/07/24.
//

import XCTest
@testable import Calculator

class OperandTests: XCTestCase {
    func test_デフォルトの初期化で生成されるOperandの値() throws {
        let operand = Operand()
        XCTAssertEqual(0, operand.decimal)
        XCTAssertEqual(nil, operand.fractionDigits)
        XCTAssertEqual("0", operand.description)
    }

    func test_小数0位の初期化で生成されるOperandの値() throws {
        let operand = Operand(decimal: 0, fractionDigits: 0)
        XCTAssertEqual(0, operand.decimal)
        XCTAssertEqual(0, operand.fractionDigits)
        XCTAssertEqual("0.", operand.description)
    }

    func test_整数・小数1位の初期化で生成されるOperandの値_0．0() throws {
        let operand = Operand(decimal: 0, fractionDigits: 1)
        XCTAssertEqual(0, operand.decimal)
        XCTAssertEqual(1, operand.fractionDigits)
        XCTAssertEqual("0.0", operand.description)
    }

    func test_整数・小数2位の初期化で生成されるOperandの値() throws {
        let operand = Operand(decimal: 0, fractionDigits: 2)
        XCTAssertEqual(0, operand.decimal)
        XCTAssertEqual(2, operand.fractionDigits)
        XCTAssertEqual("0.00", operand.description)
    }

    func test_整数・小数３位の初期化で生成されるOperandの値() throws {
        let operand = Operand(decimal: 123, fractionDigits: 3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("123.000", operand.description)
    }

    func test_小数・小数３位の初期化で生成されるOperandの値() throws {
        let operand = Operand(decimal: 123.0000, fractionDigits: 3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("123.000", operand.description)
    }

    func test_clearの入力で値をクリアする() throws {
        var operand = Operand(decimal: 123.0000, fractionDigits: 3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("123.000", operand.description)

        operand.recieve(.clear)
        XCTAssertEqual(operand, Operand())
    }

    func test_allClearの入力で値をクリアする() throws {
        var operand = Operand(decimal: 123.0000, fractionDigits: 3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("123.000", operand.description)

        operand.recieve(.allClear)
        XCTAssertEqual(operand, Operand())
    }

    func test_inversionの入力で符号が反転する() throws {
        var operand = Operand(decimal: 123.0000, fractionDigits: 3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("123.000", operand.description)

        operand.recieve(.inversion)
        XCTAssertEqual(-123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("-123.000", operand.description)
    }

    func test_percentの入力で値が100分の1の出力に変換される() throws {
        var operand = Operand(decimal: 123.0000, fractionDigits: 3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(3, operand.fractionDigits)
        XCTAssertEqual("123.000", operand.description)

        operand.recieve(.percent)
        XCTAssertEqual(1.23, operand.decimal)
        XCTAssertEqual(2, operand.fractionDigits)
        XCTAssertEqual("1.23", operand.description)
    }

    func test_dotの入力による出力の確認() throws {
        var operand = Operand(decimal: 123)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(nil, operand.fractionDigits)
        XCTAssertEqual("123", operand.description)

        operand.recieve(.dot)
        operand.recieve(.dot)
        operand.recieve(.dot)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(0, operand.fractionDigits)
        XCTAssertEqual("123.", operand.description)
    }

    func test_numberの入力による出力の確認() throws {
        var operand = Operand()
        XCTAssertEqual(0, operand.decimal)
        XCTAssertEqual(nil, operand.fractionDigits)
        XCTAssertEqual("0", operand.description)

        operand.recieve(._1)
        operand.recieve(._2)
        operand.recieve(._3)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual(nil, operand.fractionDigits)
        XCTAssertEqual("123", operand.description)

        operand.recieve(.dot)
        XCTAssertEqual(123, operand.decimal)
        XCTAssertEqual("123.", operand.description)

        operand.recieve(._0)
        operand.recieve(._0)
        operand.recieve(._0)
        XCTAssertEqual("123.000", operand.description)
    }
}
