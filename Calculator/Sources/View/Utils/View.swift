//
//  View.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/17.
//

import SwiftUI

extension View {
    func read(size value: Binding<CGSize>) -> some View {
        read { value.wrappedValue = $0 }
    }

    func read(_ value: Binding<CGRect>, in coordinateSpace: CoordinateSpace) -> some View {
        read(in: coordinateSpace) { value.wrappedValue = $0 }
    }
}

extension View {
    func read(perform: @escaping (CGSize) -> ()) -> some View {
        GeometryReader {
            preference(key: AnyPreferenceKey.self, value: $0.size)
        }
        .onPreferenceChange(AnyPreferenceKey.self, perform: perform)
    }

    func read(in coordinateSpace: CoordinateSpace, perform: @escaping (CGRect) -> ()) -> some View {
        GeometryReader {
            preference(key: AnyPreferenceKey.self, value: $0.frame(in: coordinateSpace))
        }
        .onPreferenceChange(AnyPreferenceKey.self, perform: perform)
    }
}
