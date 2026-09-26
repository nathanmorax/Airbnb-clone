//
//  APIEnvironment.swift
//  Airbnb-clone
//
//  De dónde salen los datos. Cambiar `current` es lo único que necesitas
//  para pasar de los JSON locales a un servidor real.
//

import Foundation

enum APIEnvironment {
   /// Lee los JSON de la carpeta Mocks y espera `delay` para simular la red.
   case local(delay: Duration = .milliseconds(500))
   /// Hace requests HTTP reales contra `baseURL`.
   case remote(baseURL: URL)

   /// ⬇️ Esta es "la línea" que cambias para usar un servidor.
   static let current: APIEnvironment = .local()
   // static let current: APIEnvironment = .remote(baseURL: localServer)

   /// El simulador ve el localhost de tu Mac. En un iPhone real usa la IP
   /// de tu Mac en la misma red Wi-Fi, por ejemplo http://192.168.1.100:3000
   static let localServer = URL(string: "http://localhost:3000")!
}
