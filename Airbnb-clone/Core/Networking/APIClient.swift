//
//  APIClient.swift
//  Airbnb-clone
//
//  El único lugar de la app que obtiene datos. Recibe un Endpoint,
//  consigue los bytes (del JSON local o del servidor) y los decodifica.
//

import Foundation

/// Los servicios dependen de este protocolo, no de la clase concreta.
/// En tests puedes pasar un cliente falso que regrese lo que quieras.
protocol APIClientProtocol {
   func send<Response>(_ endpoint: Endpoint<Response>) async throws -> Response
}

final class APIClient: APIClientProtocol {

   static let shared = APIClient()

   private let environment: APIEnvironment
   private let session: URLSession
   private let decoder: JSONDecoder
   private let localLoader: LocalJSONLoader

   init(environment: APIEnvironment = .current,
        session: URLSession = .shared,
        decoder: JSONDecoder = .airbnb,
        bundle: Bundle = .main) {
      self.environment = environment
      self.session = session
      self.decoder = decoder
      self.localLoader = LocalJSONLoader(bundle: bundle)
   }

   func send<Response>(_ endpoint: Endpoint<Response>) async throws -> Response {
      let data: Data

      switch environment {
      case .local(let delay):
         data = try await loadLocal(endpoint, delay: delay)
      case .remote(let baseURL):
         data = try await loadRemote(endpoint, baseURL: baseURL)
      }

      do {
         return try decoder.decode(Response.self, from: data)
      } catch {
         throw APIError.decoding(error)
      }
   }

   // MARK: - Local

   private func loadLocal<Response>(_ endpoint: Endpoint<Response>, delay: Duration) async throws -> Data {
      guard let mock = endpoint.mock else {
         throw APIError.mockNotFound("mock para \"\(endpoint.path)\"")
      }
      // Simula la latencia de la red para que veas tus estados de carga.
      try await Task.sleep(for: delay)
      return try localLoader.load(mock)
   }

   // MARK: - Remote

   private func loadRemote<Response>(_ endpoint: Endpoint<Response>, baseURL: URL) async throws -> Data {
      let request = try endpoint.makeRequest(baseURL: baseURL)

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
      return data
   }
}
