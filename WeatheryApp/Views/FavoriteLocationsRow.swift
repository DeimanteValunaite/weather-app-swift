//
//  FavoriteLocationsRow.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 03/10/2023.
//

import SwiftUI

struct FavoriteLocationsRow: View {
    @StateObject var viewModel: WeatherViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    
    var body: some View {
        HStack {
            Text(viewModel.weather.city.name)
            Spacer()
            viewModel.weatherIcon(for: viewModel.main)
                .renderingMode(.original)
                .shadow(radius: 5)
            Text(viewModel.temperature)
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
        }
        .environment(\.colorScheme, colorSchemeManager.currentScheme)
    }
}

#Preview {
    FavoriteLocationsRow(viewModel: WeatherViewModel(weather: previewData))
        .environmentObject(ColorSchemeManager())
        .environment(\.colorScheme, ColorSchemeManager().currentScheme)
}
