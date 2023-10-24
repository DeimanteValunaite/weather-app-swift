//
//  Extensions.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 03/09/2023.
//

import Foundation
import SwiftUI
import UIKit

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
