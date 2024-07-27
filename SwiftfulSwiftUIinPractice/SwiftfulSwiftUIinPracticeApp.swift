//
//  SwiftfulSwiftUIinPracticeApp.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import SwiftUI
import SwiftfulRouting
import SwiftData

@main
struct SwiftfulSwiftUIinPracticeApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
