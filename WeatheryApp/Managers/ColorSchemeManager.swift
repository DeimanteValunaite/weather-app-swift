//
//  ColorSchemeManager.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 04/10/2023.
//

import Foundation
import SwiftUI

class ColorSchemeManager: ObservableObject {
    @Published var currentScheme: ColorScheme = .light
    
    init() {
        if let storedScheme = UserDefaults.standard.string(forKey: "colorScheme") {
            self.currentScheme = ColorSchemeManager.colorScheme(from: storedScheme)
        }
    }
    
    func toggleScheme() {
        if currentScheme == .light {
            currentScheme = .dark
        } else {
            currentScheme = .light
        }
        UserDefaults.standard.setValue(ColorSchemeManager.string(from: currentScheme), forKey: "colorScheme")
    }
    
    private static func string(from colorScheme: ColorScheme) -> String {
        return colorScheme == .light ? "light" : "dark"
    }
    
    private static func colorScheme(from string: String) -> ColorScheme {
        return string == "light" ? .light : .dark
    }
}

