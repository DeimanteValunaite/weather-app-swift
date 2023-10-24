//
//  HourlyForecastView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 08/09/2023.
//

import SwiftUI

struct HourlyForecastView: View {
    @State var weatherList: ResponseData.ListResponse
    @State var weather: ResponseData
    
    @ObservedObject var viewModel: WeatherViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.formattedHourlyTime(time: weatherList.dt, timeZoneOffset: weather.city.timezone))
                .font(.caption2)
            viewModel.weatherIcon(for: weatherList.weather[0].main)
                .renderingMode(.original)
                .shadow(radius: 3)
            Text("\(viewModel.convert(weatherList.main.temp).roundDouble())°")
                .bold()
            HStack(spacing: 5) {
                Image(systemName: "drop.fill")
                    .renderingMode(.original)
                    .foregroundColor(Color("Blue"))

                Text((weatherList.main.humidity.roundDouble()) + "%")
            }
            .font(.caption)
        }
        .frame(minWidth: 10, minHeight: 80)
        .padding()
        .background(colorSchemeManager.currentScheme == .light ? Color.white : Color(.systemBackground).opacity(0.2))
        .foregroundColor(colorSchemeManager.currentScheme == .dark ? .white : .primary)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(weatherList: previewData.list[0], weather: previewData, viewModel: WeatherViewModel(weather: previewData))
            .environmentObject(ColorSchemeManager())
    }
}
