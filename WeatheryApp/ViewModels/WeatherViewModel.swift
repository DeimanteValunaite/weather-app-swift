//
//  WeatherViewModel.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 14/10/2023.
//

import Foundation
import CoreLocation
import CoreLocationUI
import Combine
import SwiftUI

class WeatherViewModel: ObservableObject {
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    var appError: AppError? = nil
    
    @Published var weather: ResponseData
    @Published var isLoading: Bool = false
    @AppStorage("location") var storageLocation: String = ""
    @Published var location = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            getWeatherForecast()
        }
    }
    
    init(weather: ResponseData) {
        self.weather = weather
        if location != "" {
            getWeatherForecast()
        }
    }
    
    
    let weeklyDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M E"
        return formatter
    }()
    
   func formattedTime(from string: String,  timeZoneOffset: Double) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "YY/MM/dd"
        
        if let date = inputFormatter.date(from: string) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: Int(timeZoneOffset))
            return weeklyDay.string(from: date)
        }
        return nil
    }
    
    func formatTime(unixTime: Date, timeZoneOffset: Double) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d, MMM"
        formatter.timeZone = TimeZone(secondsFromGMT: Int(timeZoneOffset))
        return formatter.string(from: date)
    }
    
    
    func formattedHourlyTime(time: Double, timeZoneOffset: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: Int(timeZoneOffset))
        return formatter.string(from: date)
    }
    
    static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    
    func convert(_ temp: Double) -> Double {
        let celsius = temp - 273.5
        if system == 0 {
            return celsius
        } else {
            return celsius * 9 / 5 + 32
        }
    }
    
    
    func weatherIcon(for condition: String) -> Image {
        switch condition {
        case "Clear":
            return Image(systemName: "sun.max.fill")
        case "Clouds":
            return Image(systemName: "cloud.fill")
        case "Rain":
            return Image(systemName: "cloud.rain.fill")
        case "Snow":
            return Image(systemName: "cloud.snow.fill")
        default:
            return Image(systemName: "questionmark")
        }
    }
    
    
    var name: String {
        return weather.city.name
    }
    
    var day: String {
        return weeklyDay.string(from: Date(timeIntervalSince1970: weather.list[0].dt))
    }
    
    var overview: String {
        return weather.list[0].weather[0].description.capitalized
    }
    
    var temperature: String {
        return "\(Self.numberFormatter.string(for: convert(weather.list[0].main.temp)) ?? "0")°"
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(for: convert(weather.list[0].main.tempMax)) ?? "0")°"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(for: convert(weather.list[0].main.tempMin)) ?? "0")°"
    }
    
    var feels: String {
        return "\(Self.numberFormatter.string(for: convert(weather.list[0].main.feelsLike)) ?? "0")°"
    }
    
    var pop: String {
        return "\(Self.numberFormatter2.string(for: weather.list[0].pop.roundDouble()) ?? "0%")"
    }
    
    var main: String {
        return "\(weather[0].weather[0].main)"
    }
    
    var clouds: String {
        return "\(weather.list[0].clouds)%"
    }
    
    var humidity: String {
        return "\(weather.list[0].main.humidity.roundDouble())%"
    }
    
    var wind: String {
        return "\(Self.numberFormatter.string(for: weather.list[0].wind.speed) ?? "0")m/s"
    }
    
    
    public struct DailyForecast {
        let day: String
        let maxTemp: Double
        let minTemp: Double
        let main: String
    }
    
    public var dailyForecasts: [DailyForecast] {
        let groupedData = Dictionary(grouping: weather.list) { (element) -> Substring in
            return element.localTime.prefix(10)
        }
        
        return groupedData.compactMap { (key, values) in
            guard let maxTemp = values.max(by: { $0.main.tempMax < $1.main.tempMax }),
                  let minTemp = values.min(by: { $0.main.tempMin < $1.main.tempMin }) else {
                return nil
            }
            return DailyForecast(day: String(key),
                                 maxTemp: maxTemp.main.tempMax,
                                 minTemp: minTemp.main.tempMin,
                                 main: maxTemp.weather[0].main)
        }
    }
    
 func getWeatherForecast() {
        storageLocation = location
        isLoading = true
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error as? CLError {
                switch error.code {
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    self.appError = AppError(errorString: NSLocalizedString("Unable to determine location from this text.", comment: ""))
                case .network:
                    self.appError = AppError(errorString: NSLocalizedString("You do not appear to have a network connection", comment: ""))
                default:
                    self.appError = AppError(errorString: error.localizedDescription)
                }
                self.isLoading = false
                self.appError = AppError(errorString: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let latitude = placemarks?.first?.location?.coordinate.latitude,
               let longtitude = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(latitude)&lon=\(longtitude)&appid=\(apiKey)&units=metric", dateDecodingStrategy: .secondsSince1970) { (result: Result<ResponseData,APIService.APIError>) in
                    switch result {
                    case .success(let weather):
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.weather = weather
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            self.isLoading = false
                            self.appError = AppError(errorString: errorString)
                            print(errorString)
                        }
                    }
                }
            }
        }
    }
}
