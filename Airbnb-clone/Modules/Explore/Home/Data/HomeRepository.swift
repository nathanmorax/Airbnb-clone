//
//  HomeRepository.swift
//  Airbnb-clone
//
//  El Repository es la ÚNICA puerta de entrada a los datos de la Home.
//  El ViewModel le pide "la Home" y no sabe si viene de un JSON local,
//  de un servidor o de una caché.
//

import Foundation

protocol HomeRepositoryProtocol {
   func fetchHome() async throws -> HomeFeed
}

final class HomeRepository: HomeRepositoryProtocol {

   private let client: APIClientProtocol

   init(client: APIClientProtocol = APIClient.shared) {
      self.client = client
   }

   func fetchHome() async throws -> HomeFeed {
      // 1. Pide los datos crudos (DTO) a la capa de red.
      let dto: HomeDTO = try await client.send(.home)
      // 2. Los traduce al modelo de la app.
      return dto.toDomain()
   }
}
