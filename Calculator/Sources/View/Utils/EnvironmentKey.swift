//
//  EnvironmentKey.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/21.
//

import SwiftUI

struct DragGestureLocationKey: EnvironmentKey {
    static let defaultValue: Binding<DragGesture.Location?> = .constant(.none)
}

struct KeySelectionKey: EnvironmentKey {
    static let defaultValue: KeySelection = KeySelection()
}

extension EnvironmentValues {
    var dragLocation: Binding<DragGesture.Location?> {
        get{ self[DragGestureLocationKey.self] }
        set{ self[DragGestureLocationKey.self] = newValue }
    }

    var keySelection: KeySelection {
        get{ self[KeySelectionKey.self] }
        set{ self[KeySelectionKey.self] = newValue }
    }
}
