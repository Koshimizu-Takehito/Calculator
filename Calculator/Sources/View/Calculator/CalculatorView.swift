//
//  CalculatorView.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/10.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject
    private var sceneDelegate: SceneDelegate
    @EnvironmentObject
    private var calculator: CalculatorObject

    var body: some View {
        VStack {
            margin()
            text()
            CalculatorButtonGridView()
        }
        .padding()
        .background(.black)
        .onChange(of: sceneDelegate.orientation) {
            calculator.recieve(orientation: $0)
        }
    }

    @ViewBuilder
    func margin() -> some View {
        Color.clear
            .hidden()
            .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    func text() -> some View {
        ZStack(alignment: .trailing) {
            Rectangle()
                .hidden()
                .frame(maxHeight: .infinity)
            Text(calculator.display.description)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .font(.system(size: 64).monospacedDigit())
                .foregroundColor(.white)
        }
    }
}

// MARK: -
struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .previewDevice("iPhone 13 mini")
            .environmentObject(SceneDelegate())
            .environmentObject(CalculatorObject())
    }
}
