//
//  ViewController+alertController.swift
//  MyWeather
//
//  Created by Oleksandr Kachkin on 07.12.2021.
//

import UIKit


extension ViewController {
  
  // Получение данных через АК - Вариант 2 (черех клоужер "completionHandler")
  func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: style)
    
    ac.addTextField { tf in
//      let cities = ["San Francisco", "Kyiv", "New York", "Mexico City", "London"]
//      tf.placeholder = cities.randomElement()
      tf.placeholder = "City name"
    }
    let search = UIAlertAction(title: "Search", style: .default) { action in
      let textField = ac.textFields?.first
      guard let cityName = textField?.text else { return }
      if cityName != "" {
        // Если имена городов имеют пробелы
        let city = cityName.split(separator: " ").joined(separator: "%20")
        // Получение данных через АК - Вариант 1
        // self.networkWeatherManager.fetchCurrentWeather(forCity: cityName)
        // Получение данных через АК - Вариант 2 (completionHandler)
        completionHandler(city)
      }
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    ac.addAction(search)
    ac.addAction(cancel)
    present(ac, animated: true, completion: nil)
  }
}
