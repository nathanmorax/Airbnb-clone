//
//  Services.swift
//  Airbnb-clone
//
//  Un servicio por módulo. Los view controllers dependen del protocolo,
//  no de APIClient, así que en previews o tests puedes pasar un mock.
//

import Foundation

// MARK: - Explore
//
protocol HomeServicing {
   func feed() async throws -> HomeFeed
}

final class HomeService: HomeServicing {
   private let client: APIClientProtocol
   init(client: APIClientProtocol = APIClient.shared) { self.client = client }

   func feed() async throws -> HomeFeed {
      try await client.send(.home)
   }
}

// MARK: - Search / Listing
//
protocol ListingsServicing {
   func listings(city: String?, category: String?, page: Int) async throws -> Page<Listing>
   func listing(id: Int) async throws -> Listing
   func host(id: Int) async throws -> Host
   func reviews(listingId: Int) async throws -> [Review]
}

final class ListingsService: ListingsServicing {
   private let client: APIClientProtocol
   private let pageSize: Int

   init(client: APIClientProtocol = APIClient.shared, pageSize: Int = 10) {
      self.client = client
      self.pageSize = pageSize
   }

   func listings(city: String?, category: String?, page: Int) async throws -> Page<Listing> {
      let (items, response): ([Listing], HTTPURLResponse) = try await client.sendWithResponse(
         .listings(city: city, category: category, page: page, limit: pageSize))
      let total = Int(response.value(forHTTPHeaderField: "X-Total-Count") ?? "") ?? items.count
      return Page(items: items, page: page, limit: pageSize, totalCount: total)
   }

   func listing(id: Int) async throws -> Listing {
      try await client.send(.listing(id: id))
   }

   func host(id: Int) async throws -> Host {
      try await client.send(.host(id: id))
   }

   func reviews(listingId: Int) async throws -> [Review] {
      try await client.send(.reviews(listingId: listingId))
   }
}

// MARK: - Favorites
//
protocol FavoritesServicing {
   func wishlists() async throws -> [Wishlist]
   func listings(in wishlist: Wishlist) async throws -> [Listing]
   func add(listingId: Int, to wishlistId: Int) async throws -> Favorite
   func remove(favoriteId: Int) async throws
}

final class FavoritesService: FavoritesServicing {
   private let client: APIClientProtocol
   init(client: APIClientProtocol = APIClient.shared) { self.client = client }

   func wishlists() async throws -> [Wishlist] {
      try await client.send(.wishlists)
   }

   func listings(in wishlist: Wishlist) async throws -> [Listing] {
      let ids = wishlist.favorites?.map(\.listingId) ?? []
      guard !ids.isEmpty else { return [] }
      return try await client.send(.listings(ids: ids))
   }

   func add(listingId: Int, to wishlistId: Int) async throws -> Favorite {
      try await client.send(.addFavorite(listingId: listingId, wishlistId: wishlistId))
   }

   func remove(favoriteId: Int) async throws {
      let _: EmptyResponse = try await client.send(.removeFavorite(id: favoriteId))
   }
}

// MARK: - Trips
//
protocol TripsServicing {
   func trips() async throws -> (upcoming: [Trip], past: [Trip])
}

final class TripsService: TripsServicing {
   private let client: APIClientProtocol
   init(client: APIClientProtocol = APIClient.shared) { self.client = client }

   func trips() async throws -> (upcoming: [Trip], past: [Trip]) {
      let all: [Trip] = try await client.send(.trips)
      return (all.filter { $0.status == .upcoming }.sorted { $0.checkIn < $1.checkIn },
              all.filter { $0.status == .past })
   }
}

// MARK: - Inbox
//
protocol InboxServicing {
   func conversations() async throws -> [Conversation]
   func messages(conversationId: Int) async throws -> [Message]
   func send(text: String, conversationId: Int) async throws -> Message
   func markAsRead(conversationId: Int) async throws
}

final class InboxService: InboxServicing {
   private let client: APIClientProtocol
   init(client: APIClientProtocol = APIClient.shared) { self.client = client }

   func conversations() async throws -> [Conversation] {
      try await client.send(.conversations)
   }

   func messages(conversationId: Int) async throws -> [Message] {
      try await client.send(.messages(conversationId: conversationId))
   }

   func send(text: String, conversationId: Int) async throws -> Message {
      try await client.send(.sendMessage(conversationId: conversationId, text: text))
   }

   func markAsRead(conversationId: Int) async throws {
      let _: Conversation = try await client.send(.markAsRead(conversationId: conversationId))
   }
}

// MARK: - Profile
//
protocol ProfileServicing {
   func profile() async throws -> Profile
}

final class ProfileService: ProfileServicing {
   private let client: APIClientProtocol
   init(client: APIClientProtocol = APIClient.shared) { self.client = client }

   func profile() async throws -> Profile {
      try await client.send(.profile)
   }
}
