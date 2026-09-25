//
//  Models.swift
//  Airbnb-clone
//
//  Modelos Codable que corresponden 1:1 con mock-server/db.json.
//

import Foundation

// MARK: - Home  (GET /home)
//
struct HomeFeed: Decodable {
   struct Item: Decodable, Hashable {
      let title: String
      let subtitle: String?
      let image: String?       // nombre del asset local (tus celdas actuales lo usan)
      let imageURL: String?    // path en el servidor, para cuando cargues imágenes por red
   }

   struct InfoGroup: Decodable, Hashable {
      struct Link: Decodable, Hashable {
         let title: String
         let subtitle: String?
      }
      let title: String
      let links: [Link]
   }

   let nearby: [Item]
   let stays: [Item]
   let experiences: [Item]
   let hosting: [Item]
   let info: [InfoGroup]
}

extension HomeFeed {
   /// Convierte la respuesta al mismo [Content] que hoy regresa `Section.stubData()`.
   func content(for section: Section) -> [Content] {
      switch section {
      case .nearby: return nearby.map(\.content)
      case .stays: return stays.map(\.content)
      case .experiences: return experiences.map(\.content)
      case .hosting: return hosting.map(\.content)
      case .info:
         return info.flatMap { group in
            [Content(title: group.title, subtitle: nil, image: nil, style: .title)]
            + group.links.map { Content(title: $0.title, subtitle: $0.subtitle, image: nil) }
         }
      }
   }
}

private extension HomeFeed.Item {
   var content: Content { Content(title: title, subtitle: subtitle, image: image) }
}

// MARK: - Listings  (GET /listings, GET /listings/:id)
//
struct Listing: Decodable, Hashable, Identifiable {
   struct Highlight: Decodable, Hashable {
      let icon: String      // nombre de SF Symbol
      let title: String
      let subtitle: String
   }
   struct SleepingArrangement: Decodable, Hashable {
      let room: String
      let beds: String
   }

   let id: Int
   let city: String
   let state: String
   let title: String
   let type: String
   let category: String
   let rating: Double
   let reviewCount: Int
   let pricePerNight: Int
   let currency: String
   let superhost: Bool
   let guests: Int
   let bedrooms: Int
   let beds: Int
   let baths: Double
   let hostId: Int
   let images: [String]
   let highlights: [Highlight]
   let amenities: [String]
   let description: String
   let sleepingArrangements: [SleepingArrangement]
   let cancellationPolicy: String
   let latitude: Double
   let longitude: Double
}

extension Listing {
   var formattedPrice: String {
      pricePerNight.formatted(.currency(code: currency).precision(.fractionLength(0)))
   }
   var formattedRating: String {
      rating.formatted(.number.precision(.fractionLength(2)))
   }
   /// "6 guests · 2 bedrooms · 3 beds · 2 baths"
   var capacitySummary: String {
      func plural(_ n: Double, _ word: String) -> String {
         let number = n.formatted(.number.precision(.fractionLength(0...1)))
         return "\(number) \(word)\(n == 1 ? "" : "s")"
      }
      return [plural(Double(guests), "guest"), plural(Double(bedrooms), "bedroom"),
              plural(Double(beds), "bed"), plural(baths, "bath")].joined(separator: " · ")
   }
}

/// Una página de resultados. json-server manda el total en el header X-Total-Count.
struct Page<Item: Hashable>: Hashable {
   let items: [Item]
   let page: Int
   let limit: Int
   let totalCount: Int

   var hasMore: Bool { page * limit < totalCount }
}

// MARK: - Hosts & Reviews
//
struct Host: Decodable, Hashable, Identifiable {
   let id: Int
   let name: String
   let superhost: Bool
   let joinedYear: Int
   let avatarColor: String
   let responseRate: Int
}

struct Review: Decodable, Hashable, Identifiable {
   let id: Int
   let listingId: Int
   let author: String
   let rating: Int
   let date: Date
   let text: String
}

// MARK: - Favorites  (GET /wishlists?_embed=favorites)
//
struct Wishlist: Decodable, Hashable, Identifiable {
   let id: Int
   let name: String
   let favorites: [Favorite]?   // viene con ?_embed=favorites
}

struct Favorite: Codable, Hashable, Identifiable {
   let id: Int
   let listingId: Int
   let wishlistId: Int
}

struct NewFavorite: Encodable {
   let listingId: Int
   let wishlistId: Int
}

// MARK: - Trips  (GET /trips?_expand=listing)
//
struct Trip: Decodable, Hashable, Identifiable {
   enum Status: String, Decodable {
      case upcoming, past
   }
   let id: Int
   let listingId: Int
   let checkIn: Date
   let checkOut: Date
   let guests: Int
   let status: Status
   let confirmationCode: String
   let listing: Listing?        // viene con ?_expand=listing
}

extension Trip {
   /// "Oct 16 – 18" o "Mar 30 – Apr 2"
   var formattedDates: String {
      (checkIn..<checkOut).formatted(.interval.month(.abbreviated).day())
   }
}

// MARK: - Inbox  (GET /conversations, GET /conversations/:id/messages)
//
struct Conversation: Decodable, Hashable, Identifiable {
   let id: Int
   let hostId: Int
   let listingId: Int
   let tripId: Int
   let lastMessage: String
   let updatedAt: Date
   let unread: Bool
   let host: Host?              // viene con ?_expand=host
}

struct Message: Decodable, Hashable, Identifiable {
   enum Sender: String, Decodable {
      case guest, host
   }
   let id: Int
   let conversationId: Int
   let sender: Sender
   let text: String
   let sentAt: Date
}

struct NewMessage: Encodable {
   let conversationId: Int
   let text: String
}

struct ConversationUpdate: Encodable {
   let unread: Bool
}

// MARK: - Profile  (GET /profile)
//
struct Profile: Decodable, Hashable {
   let id: Int
   let firstName: String
   let avatarURL: String?
   let memberSince: Int
   let isHost: Bool
}
