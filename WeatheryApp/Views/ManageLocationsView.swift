//
//  ManageLocationsView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 2023-09-26.
//

import SwiftUI

struct ManageLocationsView: View {
    @StateObject var viewModel: WeatherViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    
    var body: some View {
        NavigationView {
                List {
                    Section("Favorite Locations") {
                        FavoriteLocationsRow(viewModel: viewModel).environmentObject(colorSchemeManager)
                    }
                    Section("Currenct Location") {
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
                    }
                    Section {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Change Current Location")
                            Image(systemName: "location")
                            Spacer()
                        }
                        .bold()
                    }
                }
                .listStyle(.insetGrouped)
                .listRowSeparator(.hidden, edges: .all)
        }
        .background(.thickMaterial)
        .background(Color(.systemBackground).opacity(0.8))
        .foregroundColor(colorSchemeManager.currentScheme == .dark ? .white : .black)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .environment(\.colorScheme, colorSchemeManager.currentScheme)
    }
}



#Preview {
    ManageLocationsView(viewModel: WeatherViewModel(weather: previewData))
        .environmentObject(ColorSchemeManager())
        .environment(\.colorScheme, ColorSchemeManager().currentScheme)
}
