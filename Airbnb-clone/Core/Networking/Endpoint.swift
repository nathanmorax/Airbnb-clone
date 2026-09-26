//
//  Endpoint.swift
//  Airbnb-clone
//
//  Describe UN request: a dónde va, con qué método, qué parámetros lleva
//  y qué tipo de dato regresa. No hace la llamada; solo la describe.
//

import Foundation

/// Indica de qué JSON local sale la respuesta cuando la app corre en modo `.local`.
///
///     MockResource(file: "explore", keyPath: "home")
///     // → lee explore.json y regresa solo lo que está dentro de "home"
struct MockResource {
   /// Nombre del archivo en el bundle, sin la extensión .json
   let file: String
   /// Llave dentro del JSON. Acepta niveles con punto: "home.nearby".
   /// Si es nil se regresa el archivo completo.
   var keyPath: String? = nil
}

/// Para requests cuya respuesta no importa (por ejemplo, un DELETE).
struct EmptyResponse: Decodable {}

/// `Response` es el tipo que se decodifica. Gracias a él, el compilador sabe
/// qué regresa cada endpoint y no necesitas castear nada.
struct Endpoint<Response: Decodable> {
   let path: String
   var method: HTTPMethod = .get
   var queryItems: [URLQueryItem] = []
   var headers: [String: String] = [:]
   var body: Data? = nil
   var mock: MockResource? = nil

   /// Convierte la descripción en un URLRequest real para el modo `.remote`.
   func makeRequest(baseURL: URL) throws -> URLRequest {
      guard var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                           resolvingAgainstBaseURL: false) else {
         throw APIError.invalidURL(path)
      }
      if !queryItems.isEmpty {
         components.queryItems = queryItems
      }
      guard let url = components.url else {
         throw APIError.invalidURL(path)
      }

      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.timeoutInterval = 15
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

      if let body {
         request.httpBody = body
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
      return request
   }
}

extension Endpoint {
   /// Regresa una copia del endpoint con un body JSON.
   ///
   ///     let endpoint = try Endpoint<Message>(path: "messages", method: .post)
   ///        .withJSONBody(NewMessage(conversationId: 1, text: "Hola"))
   func withJSONBody<Body: Encodable>(_ body: Body, encoder: JSONEncoder = .airbnb) throws -> Endpoint {
      var copy = self
      copy.body = try encoder.encode(body)
      return copy
   }
}
