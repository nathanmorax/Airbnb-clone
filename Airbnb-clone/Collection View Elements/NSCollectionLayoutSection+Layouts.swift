//
//  NSCollectionLayoutSection+Layouts.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit

extension NSCollectionLayoutSection {
   
   static func sideScrollingTwoItem() -> NSCollectionLayoutSection {
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                            heightDimension: .estimated(85))
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .estimated(180))
      
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      section.interGroupSpacing = 8
      section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
      
      return section
   }
   
   static func sideScrollingOneItem() -> NSCollectionLayoutSection {
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                            heightDimension: .estimated(312))
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(312))
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
      
      let header = NSCollectionLayoutBoundarySupplementaryItem.header(layoutSize: headerSize)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      section.interGroupSpacing = 8
      section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
      section.boundarySupplementaryItems = [header]
      
      return section
   }
   
   static func invertedSideScrollingOneItem() -> NSCollectionLayoutSection {
      let section = sideScrollingOneItem()
      section.addBackground(style: .inverted)
      return section
   }
   
   static func footer() -> NSCollectionLayoutSection {
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                            heightDimension: .estimated(60))
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(200))
      
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item, item, item])
      
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
      
      let header = NSCollectionLayoutBoundarySupplementaryItem.header(layoutSize: headerSize)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      section.boundarySupplementaryItems = [header]
      section.interGroupSpacing = 12
      section.contentInsets = .init(top: 0, leading: 20, bottom: 20, trailing: 20)
      section.addBackground(style: .secondary)
      
      return section
   }
   
}
