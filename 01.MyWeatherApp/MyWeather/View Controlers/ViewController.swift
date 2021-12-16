//
//  ViewController.swift
//  MyWeather
//
//  Created by Oleksandr Kachkin on 07.12.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

  @IBOutlet weak var maxTemperatureLabel: UILabel!
  @IBOutlet weak var minTemperatureLabel: UILabel!
  @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
  
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var visibilityLabel: UILabel!
  
  let networkWeatherManager = NetworkWeatherManager()
  lazy var locationManager: CLLocationManager = {
    // Лок менеджер присваивается внутри клоужера
    let lm = CLLocationManager()
    lm.delegate = self
    lm.desiredAccuracy = kCLLocationAccuracyKilometer // точность в км
    lm.requestWhenInUseAuthorization() // запрос на использование геоданных. Не забудь внести правки в info.plist (Privacy - Location When In Use Usage Description)
    return lm
  }()
  
  
  @IBAction func searchPressed(_ sender: UIButton) {
    self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
      self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
      
      }
    }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setGradientBackground()
    networkWeatherManager.onCompletion = { [weak self] currentWeather in
      guard let self = self else { return }
      self.updateInterfaceWith(weather: currentWeather)
    }
    // Если у пользователя общая настройка геопозиции доступна, тогда запросим геопозицию. После этого, согласно документации, срабатывает 2 метода: 1 - locationManager(_:didUpdateLocations:) - если получилось успешно получить геопозицию; 2 - locationManager(_:didFailWithError:) - срабатывает в случае ошибки. Эти 2 метода необходимо описать в протоколе 'CLLocationManagerDelegate'
    if CLLocationManager.locationServicesEnabled() {
      locationManager.requestLocation()
    }
    
    }
  
  func updateInterfaceWith(weather: CurrentWeather) {
    DispatchQueue.main.async {
      self.cityLabel.text = weather.cityName
      self.temperatureLabel.text = weather.temperatureString
      self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString + " ˚C"
      self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
      self.maxTemperatureLabel.text = weather.tempMaximumString + " ˚C"
      self.minTemperatureLabel.text = weather.tempMinimumString + " ˚C"
      self.humidityLabel.text = weather.humidityString + " %"
      self.pressureLabel.text = weather.pressureString + " GPa"
      self.windSpeedLabel.text = weather.windSpeedString + " km/h"
      self.visibilityLabel.text = weather.visibilityString + " m"
    }
  }
  
  
  
  func setGradientBackground() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [
      UIColor.systemOrange.cgColor,
      UIColor.systemYellow.cgColor
    ]
    view.layer.insertSublayer(gradientLayer, at:0)
//    view.layer.backgroundColor.addSublayer(gradientLayer)
  }
}

// MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
  
  // получить геопозицию
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    
    // для получения погоды по текущему месторасположению
    networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
}
