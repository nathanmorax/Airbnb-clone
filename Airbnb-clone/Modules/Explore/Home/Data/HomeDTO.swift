//
//  HomeDTO.swift
//  Airbnb-clone
//
//  DTO = Data Transfer Object. Es una copia EXACTA de cómo viene el JSON
//  ("home" dentro de explore.json). No tiene lógica ni sabe nada de la UI.
//

import Foundation

struct HomeDTO: Decodable {
   let nearby: [ItemDTO]
   let stays: [ItemDTO]
   let experiences: [ItemDTO]
   let hosting: [ItemDTO]
   let info: [InfoGroupDTO]

   /// Una tarjeta: destino cercano, tipo de alojamiento, experiencia o hosting.
   struct ItemDTO: Decodable {
      let title: String
      let subtitle: String?   // en el JSON puede venir null
      let image: String?      // nombre del asset en Assets.xcassets
   }

   /// Un grupo del footer "Stay informed": un título y sus enlaces.
   struct InfoGroupDTO: Decodable {
      let title: String
      let links: [LinkDTO]
   }

   struct LinkDTO: Decodable {
      let title: String
      let subtitle: String?
   }
}
