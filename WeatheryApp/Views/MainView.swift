//
//  MainView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 13/09/2023.
//

import SwiftUI

struct MainView: View {
    @State private var isListVisible: Bool = false
    @State private var isSettingsVisible: Bool = false
    @State var weather: ResponseData
    
    @StateObject var viewModel: WeatherViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    WeatherView(weather: weather, viewModel: viewModel)
                        .environmentObject(colorSchemeManager)
                        .navigationBarItems(leading:
                                                Button(viewModel.formatTime(unixTime: Date(), timeZoneOffset: viewModel.weather.city.timezone)) {}
                            .foregroundColor(.primary)
                            .bold()
                        )
                        .navigationBarItems(leading:
                                                Button(action: {
                            isListVisible.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.primary)
                        },
                                            trailing: Button(action: {
                            isSettingsVisible.toggle()
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary)
                        }
                        )
                        .onTapGesture {
                            print("Spacer in LeftSideBarView tapped!")
                            isSettingsVisible = false
                            isListVisible  = false
                        }
                }
                
                if isListVisible {
                    HStack {
                        LeftSideBarView(viewModel: viewModel)
                            .environmentObject(colorSchemeManager)
                            .frame(width: UIScreen.main.bounds.width * 0.75)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                            .edgesIgnoringSafeArea(.all)
                            .navigationBarHidden(true)
                            .transition(.move(edge: .leading))
                            .onTapGesture {}
                        
                        Spacer()
                    }
                }
                
                if isSettingsVisible {
                    HStack {
                        Spacer()
                        RightSideBarView(viewModel: viewModel, isVisible: $isSettingsVisible)
                            .environmentObject(colorSchemeManager)
                            .frame(width: UIScreen.main.bounds.width * 0.75)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                            .edgesIgnoringSafeArea(.all)
                            .navigationBarHidden(true)
                            .transition(.move(edge: .trailing))
                            .onTapGesture {}
                    }
                }
            }
            .background(Color(.systemBackground).opacity(0.8))
            .environment(\.colorScheme, colorSchemeManager.currentScheme)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        }
    }
}
    
struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView(weather: previewData, viewModel: WeatherViewModel(weather: previewData))
            .environmentObject(ColorSchemeManager())
            .environment(\.colorScheme, ColorSchemeManager().currentScheme)
    }
}
