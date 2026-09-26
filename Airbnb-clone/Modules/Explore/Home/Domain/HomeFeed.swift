//
//  HomeFeed.swift
//  Airbnb-clone
//
//  Modelo de dominio: lo que la app entiende como "la Home".
//  Usa tus tipos existentes (Section y Content), así HomeView no cambia.
//

import Foundation

struct HomeFeed: Equatable {

   struct SectionItems: Equatable {
      let section: Section
      let items: [Content]
   }

   /// Las secciones en el orden en que se muestran.
   let sections: [SectionItems]

   var isEmpty: Bool {
      sections.allSatisfy { $0.items.isEmpty }
   }
}
