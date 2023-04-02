//
//  ContentView.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/10.
//

import SwiftUI

struct RootView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
    }

    var body: some View {
        CalculatorView()
            .background(.black)
            .accentColor(.blue)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(SceneDelegate())
            .environmentObject(CalculatorObject())
    }
}
