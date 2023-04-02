//
//  CapsuleButton.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/17.
//

import SwiftUI

extension CapsuleButton {
    init(_ key: Key, circleButtonSize: CGSize? = nil, action: @escaping () -> Void) {
        self.init(key: key, circleButtonSize: circleButtonSize ?? .zero, action: action)
    }
}

struct CapsuleButton: View {
    let key: Key
    var circleButtonSize: CGSize
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
        let height = min(circleButtonSize.width, circleButtonSize.height)
        let padding = abs(circleButtonSize.width - circleButtonSize.height)/2
        GeometryReader { geometry in
            ZStack {
                Capsule()
                    .frame(maxHeight: height)
                    .foregroundColor(key.style.backgroundColor(isSelected: isSelected))
                    .padding([.horizontal], padding)
                Capsule()
                    .foregroundColor(
                        key.style.hilitedBackgroundColor(isSelected: isSelected)
                            .opacity(isHighlited ? 0.3 : 0)
                    )
                    .padding([.horizontal], padding)
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.clear)
                        Text(key.rawValue)
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(key.style.foregroundColor(isSelected: isSelected))
                    }
                    Rectangle()
                        .foregroundColor(Color.clear)
                }
            }
            .onChange(of: dragLocation.wrappedValue) { location in
                let isHighlited = location?.isHighlited(geometry.frame(in: .global)) == true
                let isSelected = location?.isSelected(geometry.frame(in: .global)) == true
                withAnimation(.spring(response: isHighlited ? 0.1 : 0.5)) {
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

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(.number(._0)) {}
            .preferredColorScheme(.dark)
    }
}
