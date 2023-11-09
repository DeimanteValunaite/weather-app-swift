//
//  LeftSideBarView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 2023-09-25.
//

import SwiftUI
import UIKit

struct LeftSideBarView: View {
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    @StateObject var viewModel: WeatherViewModel
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search Location", text: $viewModel.location,
                              onCommit: {
                        viewModel.getWeatherForecast()
                    })
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .overlay(
                        Button(action: {
                            viewModel.location = ""
                            viewModel.getWeatherForecast()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                            .padding(.horizontal),
                        alignment: .trailing
                    )
                    
                    Button {
                        viewModel.getWeatherForecast()
                        UIApplication.shared.hideKeyboard()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .environment(\.colorScheme, colorSchemeManager.currentScheme)
                .background(.thickMaterial)
                .background(Color(.systemBackground).opacity(0.8))
                
                if !viewModel.location.isEmpty {
                    List([viewModel.weather.city], id: \.name) { cities in
                        NavigationLink(destination: MainView(weather: viewModel.weather, viewModel: viewModel).environmentObject(colorSchemeManager).navigationBarBackButtonHidden()) {
                            Text(cities.name)
                                .listRowBackground(Color(.systemBackground).opacity(0.8))
                                .environment(\.colorScheme, colorSchemeManager.currentScheme)
                        }
                    }
                    .bold()
                    .padding([.leading, .trailing])
                    .listStyle(.plain)
                }
                
                HStack() {
                    Text(Image(systemName: "star.fill")) +
                    Text(" Favorite Locations")
                    Spacer()
                }.padding()
                HStack {
                    NavigationLink(destination: AddLocationView(viewModel: viewModel).navigationBarTitle("Add Location", displayMode: .inline).environmentObject(colorSchemeManager)) {
                        Text("Add Location")
                        Spacer()
                        Image(systemName: "location")
                    }
                    .foregroundColor(.primary)
                }.padding()
                HStack {
                    NavigationLink(destination: ManageLocationsView(viewModel: viewModel).navigationBarTitle("Manage Locations", displayMode: .inline).environmentObject(colorSchemeManager)) {
                        Text("Manage Locations")
                        Spacer()
                        Image(systemName: "slider.horizontal.3")
                    }
                    .foregroundColor(.primary)
                }.padding()
                Spacer()
            }
            .padding(.top, 40)
            .padding(.bottom)
            .background(.thickMaterial)
            .background(Color(.systemBackground).opacity(0.8))
            .environment(\.colorScheme, colorSchemeManager.currentScheme)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        }
    }
}

struct LeftSideBarView_Previews: PreviewProvider {
    static var previews: some View {
        LeftSideBarView(viewModel: WeatherViewModel(weather: previewData))
            .environmentObject(ColorSchemeManager())
            .environment(\.colorScheme, ColorSchemeManager().currentScheme)
    }
}
