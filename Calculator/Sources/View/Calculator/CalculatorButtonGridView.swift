//
//  CalculatorButtonGridView.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/21.
//

import SwiftUI

struct CalculatorButtonGridView: View {
    @EnvironmentObject
    private var sceneDelegate: SceneDelegate
    @EnvironmentObject
    private var calculator: CalculatorObject
    @State
    private var circleButtonSize: CGSize = .zero
    @State
    private var dragLocation: DragGesture.Location? = .none
    @State
    private var keySelection = KeySelection()

    var body: some View {
        let items = calculator.keyLayout.itmes
        ForEach(count: items.count) { x_0 in
            HStack {
                ForEach(count: items[x_0].count) { x_1 in
                    HStack {
                        ForEach(count: items[x_0][x_1].count) { x_2 in
                            button(at: [x_0, x_1, x_2])
                        }
                    }
                }
            }
        }
        .dragGesture($dragLocation, minimumDistance: 0, coordinateSpace: .global)
        .environment(\.dragLocation, $dragLocation)
        .environment(\.keySelection, calculator.keySelection)
    }

    @ViewBuilder
    func button(at indexPath: IndexPath) -> some View {
        let key = calculator.keyLayout.keys(at: indexPath)
        let action = {
            calculator.recieve(key)
        }
        switch key {
        case .number(._0):
            CapsuleButton(key, circleButtonSize: circleButtonSize, action: action)
        case .clear:
            CircleButton(key, action: action)
                .read(size: $circleButtonSize)
        case _:
            CircleButton(key, action: action)
        }
    }
}

// MARK: -
private extension CalculatorButtonState {
    init(dragLocation: DragGesture.Location?, frame: CGRect) {
        switch dragLocation {
        case nil:
            self.init(isHighlited: false, isSelected: false)
        case let .some(location):
            self.init(
                isHighlited: location.isHighlited(frame),
                isSelected: location.isSelected(frame)
            )
        }
    }
}

// MARK: -
extension DragGesture.Location {
    func isHighlited(_ rect: CGRect) -> Bool {
        switch self {
        case let .changed(value):
            return rect.contains(value.location)
        case _:
            return false
        }
    }

    func isSelected(_ rect: CGRect) -> Bool {
        switch self {
        case let .ended(value):
            return rect.contains(value.location)
        case _:
            return false
        }
    }
}

// MARK: -
struct CalculatorButtonGridView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer(minLength: 220)
            CalculatorButtonGridView()
        }
        .padding()
        .environmentObject(SceneDelegate())
        .environmentObject(CalculatorObject())
        .previewDevice("iPhone 13 mini")
    }
}
