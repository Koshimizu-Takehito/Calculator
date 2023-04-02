//
//  SceneDelegate.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/10.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    @Published private(set) var orientation: InterfaceOrientation = .unknown

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let scene = scene as? UIWindowScene {
            orientation = .init(scene.interfaceOrientation)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let scene = scene as? UIWindowScene {
            orientation = .init(scene.interfaceOrientation)
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        didUpdate previousCoordinateSpace: UICoordinateSpace,
        interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation,
        traitCollection previousTraitCollection: UITraitCollection
    ) {
        orientation = .init(windowScene.interfaceOrientation)
    }
}
