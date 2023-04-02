//
//  CalculatorTests_Percent.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/09/04.
//

import XCTest
@testable import Calculator

private extension Calculator {
    var result: String {
        current.description
    }
}

final class CalculatorTests_Percent: XCTestCase {
    func test_通常想定する操作_パーセントは被演算子を１００で割る() throws {
        XCTContext.runActivity(named: "3%=+=") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent); XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);   XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.plus);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);   XCTAssertEqual(calc.result, "0.06")
        }
        XCTContext.runActivity(named: "3%=-") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.minus);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0")
        }
        XCTContext.runActivity(named: "3%=*") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.multiply); XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.0009")
        }
        XCTContext.runActivity(named: "3%=/") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.division); XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "1")
        }
        XCTContext.runActivity(named: "3%+===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.plus);     XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.06")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.09")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.12")
        }
        XCTContext.runActivity(named: "3%-===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.minus);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "-0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "-0.06")
        }
        XCTContext.runActivity(named: "3%*===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.multiply); XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.0009")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.000027")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.00000081")
        }
        XCTContext.runActivity(named: "3%/===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.division); XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "1")
            // TODO: 有効桁数を修正する必要がある
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "33.33333333")
            // TODO: カンマをつける必要がある、有効桁数を修正する必要がある 1,111.11111
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "1111.11111111")
        }
    }

    func test_パーセントは被演算子を二乗してから１００で割る() throws {
        XCTContext.runActivity(named: "3+%===") { _ in
            var calc = Calculator()
            calc.recieve(._3);       XCTAssertEqual(calc.result, "3")
            calc.recieve(.plus);     XCTAssertEqual(calc.result, "3")
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.09")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3.09")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3.18")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3.27")
        }
        XCTContext.runActivity(named: "3-%===") { _ in
            var calc = Calculator()
            calc.recieve(._3);       XCTAssertEqual(calc.result, "3")
            calc.recieve(.minus);    XCTAssertEqual(calc.result, "3")
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.09")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "2.91")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "2.82")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "2.73")
        }
        XCTContext.runActivity(named: "3*%===") { _ in
            var calc = Calculator()
            calc.recieve(._3);       XCTAssertEqual(calc.result, "3")
            calc.recieve(.multiply); XCTAssertEqual(calc.result, "3")
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.09")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.0027")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.000081")
        }
        XCTContext.runActivity(named: "3/%===") { _ in
            var calc = Calculator()
            calc.recieve(._3);       XCTAssertEqual(calc.result, "3")
            calc.recieve(.division); XCTAssertEqual(calc.result, "3")
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "100")
            // TODO: カンマをつける必要がある、有効桁数を修正する必要がある 3,333.33333
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3333.33333333")
            // TODO: カンマをつける必要がある、有効桁数を修正する必要がある 111,111.111
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "111111.11111111")
        }
    }

    func test_パーセントは２つの被演算子を乗算してから１００で割る() throws {
        XCTContext.runActivity(named: "3+9%===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.plus)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.27")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3.27")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3.54")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "3.81")
        }
        XCTContext.runActivity(named: "3-9%===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.minus)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.27")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "2.73")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "2.46")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "2.19")
        }
        XCTContext.runActivity(named: "3*9%===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.multiply)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.09")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.27")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.0243")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.002187")
        }
        XCTContext.runActivity(named: "3/9%===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.division)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.09")
            // TODO: 有効桁数を修正する必要がある
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "33.33333333")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "370.37037037")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "4115.22633745")
        }
        XCTContext.runActivity(named: "3+9%+===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.plus)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.27")
            calc.recieve(.plus);     XCTAssertEqual(calc.result, "3.27")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "6.54")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "9.81")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "13.08")
        }
        XCTContext.runActivity(named: "3-9%-===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.minus)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.27")
            calc.recieve(.minus);    XCTAssertEqual(calc.result, "2.73")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "-2.73")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "-5.46")
        }
        XCTContext.runActivity(named: "3*9%*===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.multiply)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.09")
            calc.recieve(.multiply); XCTAssertEqual(calc.result, "0.27")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.0729")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.019683")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.00531441")
        }
        XCTContext.runActivity(named: "3/9%/===") { _ in
            var calc = Calculator()
            calc.recieve(._3)
            calc.recieve(.division)
            calc.recieve(._9)
            calc.recieve(.percent);  XCTAssertEqual(calc.result, "0.09")
            // TODO: 有効桁数を修正する必要がある
            calc.recieve(.division); XCTAssertEqual(calc.result, "33.33333333")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "1")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.03")
            calc.recieve(.equal);    XCTAssertEqual(calc.result, "0.0009")
        }
    }
}
