//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/08/13.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    func test_初期化() throws {
        for i in 0...10000 {
            let decimal = Decimal(i)
            let fractionDigits = FractionDigits(rawValue: i)
            let operand = Operand(decimal: decimal, fractionDigits: fractionDigits)
            let calculator = Calculator(initial: operand)
            XCTAssertEqual(calculator.current, operand)
        }
    }

    func test_Clearの入力で値がリセットされる() throws {
        for _ in 0...10000 {
            var calculator = Calculator(initial: .notZero())
            calculator.recieve(.clear)
            let result = calculator.current
            XCTAssertEqual(result.decimal, 0)
            XCTAssertEqual(result.fractionDigits, nil)
        }
    }

    func test_AllClearの入力で値がリセットされる() throws {
        for _ in 0...10000 {
            var calculator = Calculator(initial: .notZero())
            calculator.recieve(.allClear)
            let result = calculator.current
            XCTAssertEqual(result.decimal, 0)
            XCTAssertEqual(result.fractionDigits, nil)
        }
    }

    func test_Inversionの入力で符号が反転する() throws {
        for _ in 0...10000 {
            var calculator = Calculator(initial: .notZero())
            let before = calculator.current
            calculator.recieve(.inversion)
            let after = calculator.current
            XCTAssertEqual(after.decimal, -before.decimal)
            XCTAssertEqual(after.fractionDigits, before.fractionDigits)
        }
    }

    func test_Percentの入力で百分率に変換する() throws {
        let operand = Operand(decimal: 123.456, fractionDigits: 3)
        var calculator = Calculator(initial: operand)

        calculator.recieve(.percent)
        let result = calculator.current
        XCTAssertEqual(123456, result.decimal * 100000)
        XCTAssertEqual(5, result.fractionDigits)
        XCTAssertEqual("1.23456", result.description)
    }

    func test_Numberの入力で数値が変更できる() throws {
        let operand = Operand()
        var calculator = Calculator(initial: operand)
        // 0
        calculator.recieve(._0)
        XCTAssertEqual(calculator.current.decimal, 0)
        XCTAssertEqual(calculator.current.fractionDigits, nil)
        XCTAssertEqual(calculator.current.description, "0")
        // 1
        calculator.recieve(._1)
        XCTAssertEqual(calculator.current.decimal, 1)
        XCTAssertEqual(calculator.current.fractionDigits, nil)
        XCTAssertEqual(calculator.current.description, "1")
        // 12
        calculator.recieve(._2)
        XCTAssertEqual(calculator.current.decimal, 12)
        XCTAssertEqual(calculator.current.fractionDigits, nil)
        XCTAssertEqual(calculator.current.description, "12")
        // 123
        calculator.recieve(._3)
        XCTAssertEqual(calculator.current.decimal, 123)
        XCTAssertEqual(calculator.current.fractionDigits, nil)
        XCTAssertEqual(calculator.current.description, "123")
        // 123.
        calculator.recieve(.dot)
        XCTAssertEqual(calculator.current.decimal, 123)
        XCTAssertEqual(calculator.current.fractionDigits, 0)
        XCTAssertEqual(calculator.current.description, "123.")
        // 123.4
        calculator.recieve(._4)
        XCTAssertEqual(calculator.current.decimal * 10, 1234)
        XCTAssertEqual(calculator.current.fractionDigits, 1)
        XCTAssertEqual(calculator.current.description, "123.4")
        // 123.4
        calculator.recieve(.dot)
        XCTAssertEqual(calculator.current.decimal * 10, 1234)
        XCTAssertEqual(calculator.current.fractionDigits, 1)
        XCTAssertEqual(calculator.current.description, "123.4")
        // 123.45
        calculator.recieve(._5)
        XCTAssertEqual(calculator.current.decimal * 100, 12345)
        XCTAssertEqual(calculator.current.fractionDigits, 2)
        XCTAssertEqual(calculator.current.description, "123.45")
        // 123.456
        calculator.recieve(._6)
        XCTAssertEqual(calculator.current.decimal * 1000, 123456)
        XCTAssertEqual(calculator.current.fractionDigits, 3)
        XCTAssertEqual(calculator.current.description, "123.456")
        // 123.456000
        calculator.recieve(._0)
        calculator.recieve(._0)
        calculator.recieve(._0)
        XCTAssertEqual(calculator.current.decimal * 1000, 123456)
        XCTAssertEqual(calculator.current.fractionDigits, 6)
        XCTAssertEqual(calculator.current.description, "123.456000")
        // 123.456
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal * 1000, 123456)
        XCTAssertEqual(calculator.current.fractionDigits, 3)
        XCTAssertEqual(calculator.current.description, "123.456")
    }

    func test_単項演算ができる() throws {
        var calculator = Calculator()
        // Input 123.
        calculator.recieve(._1)
        calculator.recieve(._2)
        calculator.recieve(._3)
        // Set operation
        calculator.recieve(.plus)
        // 9 operations.
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal, 123 * 10)
    }

    func test_二項演算ができる() throws {
        var calculator = Calculator()
        // Input 123.456.
        calculator.recieve(._1)
        calculator.recieve(._2)
        calculator.recieve(._3)
        calculator.recieve(.dot)
        calculator.recieve(._4)
        calculator.recieve(._5)
        calculator.recieve(._6)
        XCTAssertEqual(calculator.current.description, "123.456")
        // Add 654.321.
        calculator.recieve(.plus)
        calculator.recieve(._6)
        calculator.recieve(._5)
        calculator.recieve(._4)
        calculator.recieve(.dot)
        calculator.recieve(._3)
        calculator.recieve(._2)
        calculator.recieve(._1)
        XCTAssertEqual(calculator.current.description, "654.321")
        // Calculate.
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.description, "777.777")
    }

    func test_二項演算のあとに単項演算ができる() throws {
        var calculator = Calculator()
        // Input 654.
        calculator.recieve(._6)
        calculator.recieve(._5)
        calculator.recieve(._4)
        XCTAssertEqual(calculator.current.decimal, 654)
        // Add 123.
        calculator.recieve(.plus)
        calculator.recieve(._1)
        calculator.recieve(._2)
        calculator.recieve(._3)
        XCTAssertEqual(calculator.current.decimal, 123)
        // 二項演算 644 + 123.
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal, 777)
        // 単項演算 777 + 123 + 123.
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal, 1023)
    }

    func test_クリアキー入力後も単項演算ができる() throws {
        var calculator = Calculator()
        calculator.recieve(._6)
        calculator.recieve(._5)
        calculator.recieve(._4)
        calculator.recieve(.plus)
        calculator.recieve(._1)
        calculator.recieve(._2)
        calculator.recieve(._3)
        calculator.recieve(.equal)
        // 二項演算 644 + 123 = 777.
        XCTAssertEqual(calculator.current.decimal, 777)
        // クリアキーを入力
        calculator.recieve(.clear)
        XCTAssertEqual(calculator.current.decimal, 0)
        // 単項演算 0 + 123 + 123.
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal, 246)
    }

    func test_単項演算を更新できる() throws {
        var calculator = Calculator()
        calculator.recieve(._6)
        calculator.recieve(._5)
        calculator.recieve(._4)
        calculator.recieve(.plus)
        calculator.recieve(._1)
        calculator.recieve(._2)
        calculator.recieve(._3)
        calculator.recieve(.equal)
        calculator.recieve(.clear)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal, 246)
        calculator.recieve(.plus) // 単項演算 +246 を登録

        calculator.recieve(.equal)
        calculator.recieve(.equal)
        calculator.recieve(.equal)
        XCTAssertEqual(calculator.current.decimal, 246 * 4)
    }

    func test_演算子の入力後のクリアは0に置き換わる() throws {
        XCTContext.runActivity(named: "加算") { _ in
            var calculator = Calculator()
            calculator.recieve(._3)
            calculator.recieve(.plus)
            calculator.recieve(.clear)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 3 + 0)
        }
        XCTContext.runActivity(named: "減算") { _ in
            var calculator = Calculator()
            calculator.recieve(._3)
            calculator.recieve(.minus)
            calculator.recieve(.clear)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 3 - 0)
        }
        XCTContext.runActivity(named: "乗算") { _ in
            var calculator = Calculator()
            calculator.recieve(._3)
            calculator.recieve(.multiply)
            calculator.recieve(.clear)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 3 * 0)
        }
        XCTContext.runActivity(named: "除算") { _ in
            var calculator = Calculator()
            calculator.recieve(._3)
            calculator.recieve(.division)
            calculator.recieve(.clear)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 3 / 0)
        }
    }

    func test_演算子の入力後のクリアキーは0に置き換わる_複数回クリアを入力() throws {
        XCTContext.runActivity(named: "加算") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.plus)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 + 3)
        }
        XCTContext.runActivity(named: "減算") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.minus)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 - 3)
        }
        XCTContext.runActivity(named: "乗算") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.multiply)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 * 3)
        }
        XCTContext.runActivity(named: "除算") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.division)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 / 3)
        }
    }

    func test_クリアキーは演算子の入力後の被演算数のみをクリアする() throws {
        XCTContext.runActivity(named: "12+3C= ⇒ 12+0= ⇒ 12") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.plus)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 + 0)
        }
        XCTContext.runActivity(named: "12+3C34= ⇒ 12+34= ⇒ 46") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.plus)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(._4)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 + 34)
        }
        XCTContext.runActivity(named: "12+3C34C= ⇒ 12+0= ⇒ 12") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.plus)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(._4)
            calculator.recieve(.clear)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 + 0)
        }
        XCTContext.runActivity(named: "12+3C34C345= ⇒ 12+345= ⇒ 357") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.plus)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(._4)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(._4)
            calculator.recieve(._5)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 + 345)
        }
    }

    func test_クリアキーは演算子の入力後の被演算数のみをクリアする_演算子の変更ができる() throws {
        XCTContext.runActivity(named: "『12+C3C-3C3=』⇒『12-3=』⇒『9』") { _ in
            var calculator = Calculator()
            calculator.recieve(._1)
            calculator.recieve(._2)
            calculator.recieve(.plus)
            XCTAssertEqual(calculator.current.decimal, 12)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(.minus)
            XCTAssertEqual(calculator.current.decimal, 12)
            calculator.recieve(._3)
            calculator.recieve(.clear)
            calculator.recieve(._3)
            calculator.recieve(.equal)
            XCTAssertEqual(calculator.current.decimal, 12 - 3)
        }
    }
}
