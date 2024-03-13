//
//  UIColor+Inverted.swift
//  Airbnb-clone
//
//  Created by Nathan Mora on 11/03/24.
//

import UIKit

extension UIColor {
   static let invertedBackground = UIColor { traits in
      systemBackground.resolvedColor(with: traits.invertidStyle())
   }
   static let invertedLabel = UIColor { traits in
      label.resolvedColor(with: traits.invertidStyle())
   }
}

enum ColorStyle {
   case standard, inverted
}
