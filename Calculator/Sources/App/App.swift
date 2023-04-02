//
//  App.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/08/15.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor
    var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(CalculatorObject())
        }
    }
}
