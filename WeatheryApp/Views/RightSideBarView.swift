//
//  RightSideBarView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 2023-09-26.
//

import SwiftUI

struct RightSideBarView: View {
    @State private var isNotifyOn = false
    @StateObject var viewModel: WeatherViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    @Binding var isVisible: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Toggle("Notifications", isOn: $isNotifyOn)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                HStack {
                    Text("Unit")
                    Spacer()
                        Picker(selection: $viewModel.system, label: Text("System")) {
                            Text("°C").tag(0)
                            Text("°F").tag(1)
                        }
                        .pickerStyle(.automatic)
                }
                HStack {
                    Text("Auto Refresh")
                    Spacer()
                    Button("Hour") {}
                }
                HStack {
                    Text("Language")
                    Spacer()
                    Button("English (UK)") {}
                }
                HStack {
                    Text("Theme")
                    Spacer()
                    Button(action: {
                        colorSchemeManager.currentScheme = .light
                    }) {
                        Text("Light")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(colorSchemeManager.currentScheme == .light ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(colorSchemeManager.currentScheme == .light ? .white : .blue)
                    }
                    .clipShape(Capsule())
                    
                    Button(action: {
                        colorSchemeManager.currentScheme = .dark
                    }) {
                        Text("Dark")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(colorSchemeManager.currentScheme == .dark ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(colorSchemeManager.currentScheme == .dark ? .white : .blue)
                    }
                    .clipShape(Capsule())
                }
                
                Spacer()
                
                HStack {
                    Text("Help")
                        .bold()
                    Spacer()
                    Image(systemName: "questionmark.circle")
                }
                HStack {
                    Text("About Us")
                        .bold()
                    Spacer()
                    Image(systemName: "exclamationmark.circle")
                }
            }
            .padding()
            .padding(.bottom, 20)
            .padding(.top, 100)
            .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 20))
            .environment(\.colorScheme, colorSchemeManager.currentScheme)
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(leading:
                                    Button(action: {
                isVisible.toggle()
            }) {
                HStack{
                    Image(systemName: "gearshape")
                    Text("Settings")
                        .bold()
                }
                .foregroundColor((colorSchemeManager.currentScheme == .dark ? .white : .black))
            })
        }
    }
}


#Preview {
    RightSideBarView(viewModel: WeatherViewModel(weather: previewData), isVisible: .constant(false))
        .environmentObject(ColorSchemeManager())
        .environment(\.colorScheme, ColorSchemeManager().currentScheme)
}
