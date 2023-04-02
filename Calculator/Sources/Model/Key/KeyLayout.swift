//
//  KeyLayout.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/13.
//

import Foundation

public extension KeyLayout {
    enum Item: Hashable {
        case clear
        case inversion
        case percent
        case plus
        case minus
        case multiply
        case division
        case equal
        case _0
        case _1
        case _2
        case _3
        case _4
        case _5
        case _6
        case _7
        case _8
        case _9
        case dot
    }
}

public struct KeyLayout {
    public private(set) var itmes: [[[Item]]] = [
        [[.clear, .inversion, .percent, .division]],
        [[._7, ._8, ._9, .multiply]],
        [[._4, ._5, ._6, .minus]],
        [[._1, ._2, ._3, .plus]],
        [[._0], [.dot, .equal]],
    ]

    public private(set) var keys: [[[Key]]] = [
        [[.clear(.allClear), .inversion(), .percent(), .operation(.division)]],
        [[.number(._7), .number(._8), .number(._9), .operation(.multiply)]],
        [[.number(._4), .number(._5), .number(._6), .operation(.minus)]],
        [[.number(._1), .number(._2), .number(._3), .operation(.plus)]],
        [[.number(._0)], [.dot(), .equal()]],
    ]

    private var clearKey: Key.Clear {
        get {
            guard case let .clear(clear) = keys[0][0][0] else {
                fatalError()
            }
            return clear
        }
        set {
            keys[0][0][0] = .clear(newValue)
        }
    }
}

extension KeyLayout {
    public func keys(at indexPath: IndexPath) -> Key {
        keys[indexPath[0]][indexPath[1]][indexPath[2]]
    }

    public mutating func recieve(key: Key, operand: Operand) {
        switch key {
        case .number where operand != .zero:
            clearKey = .clear
        case .dot:
            clearKey = .clear
        case .clear(.clear):
            clearKey = .allClear
        case _:
            break
        }
    }
}
