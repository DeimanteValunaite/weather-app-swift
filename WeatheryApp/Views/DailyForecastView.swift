//
//  DailyForecastView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 12/09/2023.
//

import SwiftUI

struct DailyForecastView: View {
    var dailyForecast: WeatherViewModel.DailyForecast
    
    @StateObject var viewModel: WeatherViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    
    var body: some View {
        HStack {
            HStack {
                Text(viewModel.formattedTime(from: dailyForecast.day, timeZoneOffset: viewModel.weather.city.timezone) ?? viewModel.day)
                Spacer()
            }
            Spacer()
            HStack {
                viewModel.weatherIcon(for: dailyForecast.main)
                    .renderingMode(.original)
                    .shadow(radius: 5)
                Text(dailyForecast.main)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text("\(viewModel.convert(dailyForecast.maxTemp).roundDouble())°")
                Text("\(viewModel.convert(dailyForecast.minTemp).roundDouble())°")
                Spacer()
            }
            .bold()
          
        }
        .padding()
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView(dailyForecast: WeatherViewModel.DailyForecast(day: "2023-09-21", maxTemp: 20, minTemp: 14, main: "Sunny"), viewModel: WeatherViewModel(weather: previewData))
            .environmentObject(ColorSchemeManager())
    }
}
