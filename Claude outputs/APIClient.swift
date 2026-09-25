//
//  APIClient.swift
//  Airbnb-clone
//
//  Cliente HTTP genérico: arma el request, lo manda con URLSession,
//  valida el status code y decodifica la respuesta.
//

import Foundation

enum APIConfig {
   #if targetEnvironment(simulator)
   /// El simulador ve el localhost de tu Mac.
   static let baseURL = URL(string: "http://localhost:3000")!
   #else
   /// En un iPhone real usa la IP de tu Mac en la misma red Wi-Fi
   /// (Ajustes del Sistema → Wi-Fi → Detalles → Dirección IP).
   static let baseURL = URL(string: "http://192.168.1.100:3000")!
   #endif
}

protocol APIClientProtocol {
   var baseURL: URL { get }
   func send<Response>(_ endpoint: Endpoint<Response>) async throws -> Response
   func sendWithResponse<Response>(_ endpoint: Endpoint<Response>) async throws -> (Response, HTTPURLResponse)
}

extension APIClientProtocol {
   /// Convierte un path relativo del JSON ("images/estes-park.png") en URL completa.
   func url(for path: String?) -> URL? {
      guard let path, !path.isEmpty else { return nil }
      if let absolute = URL(string: path), absolute.scheme != nil { return absolute }
      return baseURL.appendingPathComponent(path)
   }
}

final class APIClient: APIClientProtocol {

   static let shared = APIClient()

   let baseURL: URL
   private let session: URLSession
   private let decoder: JSONDecoder

   init(baseURL: URL = APIConfig.baseURL, session: URLSession = .shared) {
      self.baseURL = baseURL
      self.session = session
      self.decoder = JSONDecoder()
      self.decoder.dateDecodingStrategy = .flexibleISO8601
   }

   func send<Response>(_ endpoint: Endpoint<Response>) async throws -> Response {
      try await sendWithResponse(endpoint).0
   }

   func sendWithResponse<Response>(_ endpoint: Endpoint<Response>) async throws -> (Response, HTTPURLResponse) {
      let request = try endpoint.urlRequest(baseURL: baseURL)

      let data: Data
      let response: URLResponse
      do {
         (data, response) = try await session.data(for: request)
      } catch let error as URLError {
         throw APIError.transport(error)
      }

      guard let http = response as? HTTPURLResponse else {
         throw APIError.invalidResponse
      }
      guard (200..<300).contains(http.statusCode) else {
         throw APIError.http(statusCode: http.statusCode, data: data)
      }

      do {
         let decoded = try decoder.decode(Response.self, from: data)
         return (decoded, http)
      } catch {
         throw APIError.decoding(error)
      }
   }
}

// MARK: - Fechas ISO 8601 con o sin milisegundos
//
extension JSONDecoder.DateDecodingStrategy {
   static let flexibleISO8601: JSONDecoder.DateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let string = try container.decode(String.self)

      let withFraction = ISO8601DateFormatter()
      withFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      if let date = withFraction.date(from: string) { return date }

      let plain = ISO8601DateFormatter()
      plain.formatOptions = [.withInternetDateTime]
      if let date = plain.date(from: string) { return date }

      throw DecodingError.dataCorruptedError(in: container,
                                             debugDescription: "Fecha inválida: \(string)")
   }
}
