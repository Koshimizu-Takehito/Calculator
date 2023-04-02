//
//  CalculatorObject.swift
//  CalculatorTests
//
//  Created by Takehito Koshimizu on 2022/08/13.
//

import SwiftUI

@MainActor
public final class CalculatorObject: ObservableObject {
    private var calculator: Calculator
    @Published
    public private(set) var keyLayout: KeyLayout
    @Published
    public private(set) var keySelection: KeySelection
    @Published
    public private(set) var display: CalculatorDisplay

    init() {
        self.calculator = Calculator()
        self.keyLayout = KeyLayout()
        self.keySelection = KeySelection()
        self.display = CalculatorDisplay(operand: calculator.current)
    }
}

// MARK: -
extension CalculatorObject: KeyRecievable {
    public func recieve(_ key: Key) {
        calculator.recieve(key)
        keyLayout.recieve(key: key, operand: calculator.current)
        keySelection.recieve(key: key)
        display.recieve(operand: calculator.current)
    }
}

// MARK: -
extension CalculatorObject: InterfaceOrientationRecievable {
    public func recieve(orientation: InterfaceOrientation) {
        display.recieve(orientation: orientation)
    }
}
