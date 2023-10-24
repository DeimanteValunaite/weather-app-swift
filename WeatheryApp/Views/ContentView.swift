//
//  ContentView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 03/09/2023.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import WeatherKit

struct ContentView: View {
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel: WeatherViewModel
    var weatherManager = WeatheryManager()
    @State var weather: ResponseData?
    
    var body: some View {
        VStack {
            if let location =
                locationManager.location {
                if weather == weather {
                    MainView(weather: weather ?? viewModel.weather, viewModel: viewModel)
                        .environmentObject(colorSchemeManager)
                }  else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)

                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                        .environmentObject(locationManager)
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                        .environmentObject(colorSchemeManager)
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel(weather: previewData))
            .environmentObject(ColorSchemeManager())
    }
}
