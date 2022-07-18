//
//  ForEach.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/09/03.
//

import SwiftUI

// MARK: -
extension ForEach where Data == Range<ID>, ID: ExpressibleByIntegerLiteral, Content: View {
    init(count: ID, @ViewBuilder content: @escaping (ID) -> Content) {
        self.init(0..<count, id: \.self, content: content)
    }
}
