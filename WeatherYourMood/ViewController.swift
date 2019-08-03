//
//  ViewController.swift
//  WeatherYourMood
//
//  Created by Jackson Ho on 8/2/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  
  let networkManager = NetworkManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .yellow
    
    networkManager.getWeatherFromOneCity("London") { (result) in
      switch result {
      case .success(let data):
        print(data)
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  
}

