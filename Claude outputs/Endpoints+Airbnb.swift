//
//  Endpoints+Airbnb.swift
//  Airbnb-clone
//
//  Todos los endpoints del mock server en un solo lugar.
//  Cada uno ya sabe qué tipo regresa, así que la llamada queda:
//  let feed = try await client.send(.home)
//

import Foundation

// MARK: - Explore
//
extension Endpoint where Response == HomeFeed {
   static var home: Self { Endpoint(path: "home") }
}

// MARK: - Listings
//
extension Endpoint where Response == [Listing] {
   /// GET /listings?city=Estes%20Park&category=cabins-cottages&_page=1&_limit=10
   static func listings(city: String? = nil, category: String? = nil, page: Int = 1, limit: Int = 10) -> Self {
      var items = [URLQueryItem(name: "_page", value: String(page)),
                   URLQueryItem(name: "_limit", value: String(limit))]
      if let city { items.append(URLQueryItem(name: "city", value: city)) }
      if let category { items.append(URLQueryItem(name: "category", value: category)) }
      return Endpoint(path: "listings", queryItems: items)
   }

   /// GET /listings?id=1&id=6 (para los lugares de una wishlist)
   static func listings(ids: [Int]) -> Self {
      Endpoint(path: "listings", queryItems: ids.map { URLQueryItem(name: "id", value: String($0)) })
   }
}

extension Endpoint where Response == Listing {
   static func listing(id: Int) -> Self { Endpoint(path: "listings/\(id)") }
}

extension Endpoint where Response == Host {
   static func host(id: Int) -> Self { Endpoint(path: "hosts/\(id)") }
}

extension Endpoint where Response == [Review] {
   static func reviews(listingId: Int) -> Self {
      Endpoint(path: "listings/\(listingId)/reviews",
               queryItems: [URLQueryItem(name: "_sort", value: "date"),
                            URLQueryItem(name: "_order", value: "desc")])
   }
}

// MARK: - Favorites
//
extension Endpoint where Response == [Wishlist] {
   static var wishlists: Self {
      Endpoint(path: "wishlists", queryItems: [URLQueryItem(name: "_embed", value: "favorites")])
   }
}

extension Endpoint where Response == [Favorite] {
   static var favorites: Self { Endpoint(path: "favorites") }
}

extension Endpoint where Response == Favorite {
   static func addFavorite(listingId: Int, wishlistId: Int) -> Self {
      .withBody("favorites", method: .post, body: NewFavorite(listingId: listingId, wishlistId: wishlistId))
   }
}

extension Endpoint where Response == EmptyResponse {
   static func removeFavorite(id: Int) -> Self {
      Endpoint(path: "favorites/\(id)", method: .delete)
   }
}

// MARK: - Trips
//
extension Endpoint where Response == [Trip] {
   static var trips: Self {
      Endpoint(path: "trips", queryItems: [URLQueryItem(name: "_expand", value: "listing"),
                                           URLQueryItem(name: "_sort", value: "checkIn"),
                                           URLQueryItem(name: "_order", value: "desc")])
   }
}

// MARK: - Inbox
//
extension Endpoint where Response == [Conversation] {
   static var conversations: Self {
      Endpoint(path: "conversations", queryItems: [URLQueryItem(name: "_expand", value: "host"),
                                                   URLQueryItem(name: "_sort", value: "updatedAt"),
                                                   URLQueryItem(name: "_order", value: "desc")])
   }
}

extension Endpoint where Response == Conversation {
   static func markAsRead(conversationId: Int) -> Self {
      .withBody("conversations/\(conversationId)", method: .patch, body: ConversationUpdate(unread: false))
   }
}

extension Endpoint where Response == [Message] {
   static func messages(conversationId: Int) -> Self {
      Endpoint(path: "conversations/\(conversationId)/messages",
               queryItems: [URLQueryItem(name: "_sort", value: "sentAt"),
                            URLQueryItem(name: "_order", value: "asc")])
   }
}

extension Endpoint where Response == Message {
   static func sendMessage(conversationId: Int, text: String) -> Self {
      .withBody("messages", method: .post, body: NewMessage(conversationId: conversationId, text: text))
   }
}

// MARK: - Profile
//
extension Endpoint where Response == Profile {
   static var profile: Self { Endpoint(path: "profile") }
}
