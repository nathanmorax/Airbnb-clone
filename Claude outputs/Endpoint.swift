//
//  Endpoint.swift
//  Airbnb-clone
//
//  Describe un request y el tipo que regresa. El tipo genérico
//  hace que el compilador sepa qué decodificar en cada llamada.
//

import Foundation

enum HTTPMethod: String {
   case get = "GET"
   case post = "POST"
   case patch = "PATCH"
   case delete = "DELETE"
}

/// Para respuestas sin contenido útil (json-server responde `{}` al borrar).
struct EmptyResponse: Decodable {}

struct Endpoint<Response: Decodable> {
   var path: String
   var method: HTTPMethod = .get
   var queryItems: [URLQueryItem] = []
   var body: Data? = nil

   func urlRequest(baseURL: URL) throws -> URLRequest {
      guard var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                           resolvingAgainstBaseURL: false) else {
         throw APIError.invalidURL
      }
      if !queryItems.isEmpty {
         components.queryItems = queryItems
      }
      guard let url = components.url else { throw APIError.invalidURL }

      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.timeoutInterval = 15
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      if let body {
         request.httpBody = body
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
      return request
   }
}

extension Endpoint {
   static func withBody<Body: Encodable>(_ path: String, method: HTTPMethod, body: Body) -> Endpoint {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      return Endpoint(path: path, method: method, body: try? encoder.encode(body))
   }

   /// Agrega ?_fail=500 para que el mock server responda con ese error.
   /// Úsalo para probar tus pantallas de error: `.listing(id: 1).failing(with: 500)`
   func failing(with statusCode: Int = 500) -> Endpoint {
      var copy = self
      copy.queryItems.append(URLQueryItem(name: "_fail", value: String(statusCode)))
      return copy
   }
}
