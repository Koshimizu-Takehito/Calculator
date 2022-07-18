//
//  CircleButton.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/10.
//

import SwiftUI

// MARK: -
public struct CalculatorButtonState {
    public let isHighlited: Bool
    public let isSelected: Bool

    public init(isHighlited: Bool = false, isSelected: Bool = false) {
        self.isHighlited = isHighlited
        self.isSelected = isSelected
    }
}

extension CircleButton {
    init(_ key: Key, action: @escaping () -> Void) {
        self.init(key: key, action: action)
    }
}

struct CircleButton: View {
    let key: Key
    var action: () -> Void = {}
    @Environment(\.dragLocation)
    var dragLocation
    @Environment(\.keySelection)
    var keySelection
    @State
    var isHighlited = false
    @State
    var isSelected = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .foregroundColor(key.style.backgroundColor(isSelected: isSelected))
                Circle()
                    .foregroundColor(
                        key.style.hilitedBackgroundColor(isSelected: isSelected)
                            .opacity(isHighlited ? 0.3 : 0)
                    )
                Text(key.rawValue)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(key.style.foregroundColor(isSelected: isSelected))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onChange(of: dragLocation.wrappedValue) { location in
                let isHighlited = location?.isHighlited(geometry.frame(in: .global)) == true
                let isSelected = location?.isSelected(geometry.frame(in: .global)) == true
                withAnimation(.spring(response: isHighlited ? 0.1 : 1)) {
                    self.isHighlited = isHighlited
                }
                if isSelected {
                    action()
                }
            }
            .onChange(of: keySelection) { newValue in
                withAnimation(.spring(response: isSelected ? 0.3 : 0.3)) {
                    self.isSelected = newValue.isSelected(key: key)
                }
            }
        }
    }
}

struct CalculatorButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(key: .number(._0))
            .preferredColorScheme(.dark)
    }
}
