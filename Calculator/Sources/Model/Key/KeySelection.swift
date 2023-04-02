//
//  KeySelection.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/28.
//

public struct KeySelection: Hashable {
    private var value = [Key: Bool]()
    private var lastOperation: Key.OperationName?

    public mutating func recieve(key: Key) {
        switch key {
        case .number, .dot:
            value.removeAll(keepingCapacity: true)
        case .operation(let operation):
            var value = value
            value.removeAll(keepingCapacity: true)
            value[key] = true
            self.value = value
            lastOperation = operation
        case .clear(.allClear), .equal:
            value.removeAll(keepingCapacity: true)
            lastOperation = nil
        case .clear(.clear):
            if let lastOperation = lastOperation {
                value[.operation(lastOperation)] = true
            }
        case .inversion, .percent:
            break
        }
    }

    public func isSelected(key: Key) -> Bool {
        value[key, default: false]
    }
}
