//
//  WeatheryApp.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 03/09/2023.
//

import SwiftUI
import UIKit

@main
struct WeatheryApp: App {
    @StateObject var colorSchemeManager = ColorSchemeManager()
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: WeatherViewModel(weather: previewData))
                .environmentObject(colorSchemeManager)
                .environmentObject(LocationManager())
        }
    }
}
