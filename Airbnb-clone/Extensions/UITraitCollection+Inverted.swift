//
//  UITraitCollection+Inverted.swift
//  Airbnb-clone
//
//  Created by Nathan Mora on 11/03/24.
//

import UIKit

extension UITraitCollection {
   
   private static let lightStyle: UITraitCollection = .init(userInterfaceStyle: .light)
   private static let darkStyle: UITraitCollection = .init(userInterfaceStyle: .dark)

   func invertidStyle() -> UITraitCollection {
      switch userInterfaceStyle {
      case .dark:
         return UITraitCollection(traitsFrom: [self, Self.lightStyle])
      case .light, .unspecified:
         return UITraitCollection(traitsFrom: [self, Self.darkStyle])
      @unknown default:
         return self
      }
   }
}
