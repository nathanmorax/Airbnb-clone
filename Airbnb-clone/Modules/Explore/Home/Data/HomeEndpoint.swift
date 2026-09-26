//
//  HomeEndpoint.swift
//  Airbnb-clone
//
//  Describe el request de la Home: en el servidor sería GET /home,
//  y en modo local sale de explore.json → "home".
//

import Foundation

extension Endpoint where Response == HomeDTO {
   static var home: Self {
      Endpoint(path: "home",
               mock: MockResource(file: "explore", keyPath: "home"))
   }
}
