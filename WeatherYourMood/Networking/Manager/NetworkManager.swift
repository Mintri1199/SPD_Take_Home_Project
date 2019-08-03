//
//  NetworkManager.swift
//  Magic_Tokens
//
//  Created by Jackson Ho on 3/20/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation
import UIKit

enum NetworkEnvironment {
  case qa
  case production
  case staging
}

struct NetworkManager {
  
  static let environment: NetworkEnvironment = .production
  private let weatherRouter = Router<OpenWeatherApi>()
  
  enum NetworkReponse: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad Request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
  }
  
  
  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, NetworkReponse> {
    switch response.statusCode {
    case 200...299: return Result.success("Success")
    case 401...500: return Result.failure(.authenticationError)
    case 501...599: return Result.failure(.badRequest)
    case 600: return Result.failure(.outdated)
    default: return Result.failure(.failed)
    }
  }
  
  private func getAPIKey(_ completion: @escaping(String) -> Void) {
    var format = PropertyListSerialization.PropertyListFormat.xml
    var data: [String: AnyObject] = [:]
    let path: String? = Bundle.main.path(forResource: "Info", ofType: "plist")
    let xmlContents = FileManager.default.contents(atPath: path!)
    
    do {
      if let xmlContents = xmlContents {
        data = try (PropertyListSerialization.propertyList(from:xmlContents, options:.mutableContainersAndLeaves, format:&format) as? [String:AnyObject] ?? ["Error":"Error" as AnyObject])
        
        if let apiKey = data["APPID"] as? String {
          completion(apiKey)
        } else {
          print("APPID is not String, ill config")
        }
      }
    } catch {
      print("Can not read Info.plist: \(error)")
    }
  }
  
  func getWeatherFromOneCity(_ city: String, _ completion: @escaping (Result<WeatherModel, NetworkReponse>) -> Void) {
    
    if city.isEmpty {
      print("Check your network connection")
      return
    }
    
    getAPIKey { (key) in
      self.weatherRouter.request(.getWeather(key, city), completion: { (data, response, error) in
        
        if error != nil {
          print("Check your network connection")
          return
        }
        
        if let response = response as? HTTPURLResponse {
          let result = self.handleNetworkResponse(response)
          switch result {
          case .success:
            guard let responseData = data  else { completion(.failure(.noData)); return }
            
            do {
              let parsedJson = try JSONDecoder().decode(WeatherModel.self, from: responseData)
              completion(.success(parsedJson))
              
            } catch {
              completion(.failure(.unableToDecode))
            }
          case .failure(let networkFailureError):
            completion(.failure(networkFailureError))
          }
        }
      })
    }
  }
}
