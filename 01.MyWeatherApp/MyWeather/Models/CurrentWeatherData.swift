//
//  CurrentWeatherData.swift
//  MyWeather
//
//  Created by Oleksandr Kachkin on 08.12.2021.
//

import Foundation

// создадим модель, которая будет брать 11 полей из всего ответа JSON

struct CurrentWeatherData: Codable {
  let name: String
  let main: Main
  let visibility: Int
  let wind: Wind
  let weather: [Weather]
}

struct Main: Codable {
  let temp: Double
  let tempMin: Double
  let tempMax: Double
  let feelsLike: Double
  let humidity: Int
  let pressure: Int
  
  enum CodingKeys: String, CodingKey {
    case temp
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case feelsLike = "feels_like"
    case humidity
    case pressure
  }
}

struct Wind: Codable {
  let speed: Double
}

struct Weather: Codable {
  let id: Int
}
