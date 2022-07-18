//
//  View+DragGesture.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/21.
//

import SwiftUI

extension DragGesture {
    enum Location: Equatable {
        case changed(Value)
        case ended(Value)
    }
}

extension View {
    func dragGesture(
        _ binding: Binding<DragGesture.Location?>,
        minimumDistance: CGFloat = 10,
        coordinateSpace: CoordinateSpace = .local
    ) -> some View {
        gesture(
            DragGesture(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace)
                .onChanged { value in
                    binding.wrappedValue = .changed(value)
                }
                .onEnded { value in
                    binding.wrappedValue = .ended(value)
                }
        )
    }
}

