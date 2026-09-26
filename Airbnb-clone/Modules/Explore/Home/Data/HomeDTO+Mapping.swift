//
//  HomeDTO+Mapping.swift
//  Airbnb-clone
//
//  Traduce el DTO (forma del JSON) al modelo que usa la app (HomeFeed).
//  Si mañana cambia el JSON, solo se ajusta este archivo.
//

import Foundation

extension HomeDTO {

   func toDomain() -> HomeFeed {
      // Importante: siempre se regresan las 5 secciones y en el orden de
      // Section.allCases, porque HomeView usa ese orden para elegir el layout
      // y el header de cada sección.
      let sections = Section.allCases.map { section in
         HomeFeed.SectionItems(section: section, items: items(for: section))
      }
      return HomeFeed(sections: sections)
   }

   private func items(for section: Section) -> [Content] {
      switch section {
      case .nearby: return nearby.map(\.content)
      case .stays: return stays.map(\.content)
      case .experiences: return experiences.map(\.content)
      case .hosting: return hosting.map(\.content)
      case .info:
         // Cada grupo se aplana: primero su título (estilo .title)
         // y después sus enlaces, igual que en Section.stubData().
         return info.flatMap { group -> [Content] in
            let header = Content(title: group.title, subtitle: nil, image: nil, style: .title)
            let links = group.links.map { Content(title: $0.title, subtitle: $0.subtitle, image: nil) }
            return [header] + links
         }
      }
   }
}

private extension HomeDTO.ItemDTO {
   var content: Content {
      Content(title: title, subtitle: subtitle, image: image)
   }
}
