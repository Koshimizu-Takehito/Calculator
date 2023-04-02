//
//  AnyPreferenceKey.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/21.
//

import SwiftUI

// MARK: -
public protocol DefaultValueProvidable {
    static var defaultValue: Self { get }
}

// MARK: -
struct AnyPreferenceKey<Value: DefaultValueProvidable>: PreferenceKey {
    static var defaultValue: Value { .defaultValue }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

// MARK: -
public protocol ZeroProvidable: DefaultValueProvidable {
    static var zero: Self { get }
}

extension ZeroProvidable {
    public static var defaultValue: Self { zero }
}

// MARK: -
extension CGRect: ZeroProvidable {}
extension CGPoint: ZeroProvidable {}
extension CGSize: ZeroProvidable {}
