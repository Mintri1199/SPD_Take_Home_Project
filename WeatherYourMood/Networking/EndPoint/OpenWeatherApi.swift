//
//  OpenWeatherApi.swift
//  WeatherYourMood
//
//  Created by Jackson Ho on 8/2/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation

public enum OpenWeatherApi {
  case getWeather(_ key: String, _ city: String)
}

extension OpenWeatherApi: EndPointType {
  
  var enviromentBaseURL: String {
    switch NetworkManager.environment {
    default:
      return "https:api.openweathermap.org/data/2.5/"
    }
  }
  
  var baseURL: URL {
    guard let url = URL(string: enviromentBaseURL) else { fatalError("BaseURL could not be configure") }
    return url
  }
  
  var path: String {
    switch self {
    case .getWeather:
      return "weather"
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
  
  var task: HTTPTask {
    switch self {
    case .getWeather(let key, let city):
      return .requestParameter(bodyParameters: nil, urlParameters: ["q" : city, "appid" : key])
    }
  }
  
  var headers: HTTPHeaders? {
    return nil 
  }
}
