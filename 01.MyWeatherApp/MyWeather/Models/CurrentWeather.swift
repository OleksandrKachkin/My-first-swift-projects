//
//  CurrentWeather.swift
//  MyWeather
//
//  Created by Oleksandr Kachkin on 08.12.2021.
//

import Foundation

struct CurrentWeather {
  let cityName: String
  
  let temperature: Double
  var temperatureString: String {
    // Округляем до 0 знаков после запятой
    return String(format: "%.0f", temperature)
  }
  
  let feelsLikeTemperature: Double
  var feelsLikeTemperatureString: String {
    return String(format: "%.0f", feelsLikeTemperature)
  }
  
  let conditionCode: Int
  var systemIconNameString: String {
    switch conditionCode {
    case 200...232: return "cloud.bolt.rain.fill"
    case 300...321: return "cloud.drizzle.fill"
    case 400...531: return "cloud.rain.fill"
    case 600...622: return "cloud.snow.fill"
    case 701...781: return "smoke.fill"
    case 800: return "sun.min.fill"
    case 801...804: return "cloud.fill"
    default: return "nosign"
    }
  }
  
  let visibility: Int
  var visibilityString: String {
    return "\(visibility)"
  }
  
  let humidity: Int
  var humidityString: String {
    return "\(humidity)"
  }
  
  let pressure: Int
  var pressureString: String {
    return "\(pressure)"
  }
  
  let tempMinimum: Double
  var tempMinimumString: String {
    return String(format: "%.0f", tempMinimum)
  }
  
  let tempMaximum: Double
  var tempMaximumString: String {
    return String(format: "%.0f", tempMaximum)
    }
  
  let windSpeed: Double
  var windSpeedString: String {
    return String(format: "%.0f", windSpeed)
  }
  
  // Создадим 'failable initializer', который может вернуть nil и заполним их свойства JSON-данными
  init?(currentWeatherData: CurrentWeatherData) {
    cityName = currentWeatherData.name
    temperature = currentWeatherData.main.temp
    tempMinimum = currentWeatherData.main.tempMin
    tempMaximum = currentWeatherData.main.tempMax
    feelsLikeTemperature = currentWeatherData.main.feelsLike
    humidity = currentWeatherData.main.humidity
    pressure = currentWeatherData.main.pressure
    
    
    conditionCode = currentWeatherData.weather.first!.id
    visibility = currentWeatherData.visibility
    windSpeed = currentWeatherData.wind.speed
    
  }
}
