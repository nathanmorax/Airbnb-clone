//
//  JSONCoding+Airbnb.swift
//  Airbnb-clone
//
//  Un decoder y un encoder configurados igual en toda la app.
//

import Foundation

extension JSONDecoder {
   /// Decoder de la app: entiende fechas ISO 8601 con y sin milisegundos
   /// ("2026-10-16T22:00:00Z" y "2026-10-16T22:00:00.123Z").
   static var airbnb: JSONDecoder {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .flexibleISO8601
      return decoder
   }
}

extension JSONEncoder {
   static var airbnb: JSONEncoder {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      return encoder
   }
}

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
