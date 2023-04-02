//
//  ButtonStyle.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/18.
//

import SwiftUI

struct ButtonStyle {
    let foregroundColor: Color
    let backgroundColor: Color
    let selectedForegroundColor: Color
    let selectedBackgroundColor: Color

    let hilitedBackgroundColor: Color
    let selectedHilitedBackgroundColor: Color

    func foregroundColor(isSelected: Bool) -> Color {
        isSelected ? selectedForegroundColor : foregroundColor
    }

    func backgroundColor(isSelected: Bool) -> Color {
        isSelected ? selectedBackgroundColor : backgroundColor
    }

    func hilitedBackgroundColor(isSelected: Bool) -> Color {
        isSelected ? selectedHilitedBackgroundColor : hilitedBackgroundColor
    }
}

extension ButtonStyle {
    init(foregroundColor: Color, backgroundColor: Color) {
        self.init(
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            selectedForegroundColor: foregroundColor,
            selectedBackgroundColor: backgroundColor,
            hilitedBackgroundColor: .white,
            selectedHilitedBackgroundColor: .white
        )
    }
}

extension ButtonStyle {
    static let lightGray = Self.init(
        foregroundColor: Color(uiColor: .label),
        backgroundColor: .gray
    )
    static let darkGray = Self.init(
        foregroundColor: Color(uiColor: .systemBackground),
        backgroundColor: .secondary
    )
    static let orange = Self.init(
        foregroundColor: Color(uiColor: .systemBackground),
        backgroundColor: .orange
    )
}

extension Key {
    var style: ButtonStyle {
        switch self {
        case .clear, .inversion, .percent:
            return .init(
                foregroundColor: .black,
                backgroundColor: .gray
            )
        case .operation:
            return .init(
                foregroundColor: .white,
                backgroundColor: .blue,
                selectedForegroundColor: .blue,
                selectedBackgroundColor: .white,
                hilitedBackgroundColor: .white,
                selectedHilitedBackgroundColor: .blue
            )
        case .equal:
            return .init(
                foregroundColor: .white,
                backgroundColor: .blue
            )
        case .number, .dot:
            return .init(
                foregroundColor: .white,
                backgroundColor: .secondary
            )
        }
    }
}
