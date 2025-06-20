//
//  UIFont+Custom.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit

extension UIFont {
   
   private static var title2: UIFont {
      UIFontMetrics(forTextStyle: .title2)
         .scaledFont(for: .systemFont(ofSize: 18, weight: .bold))
   }
   
   private static var title4: UIFont {
      UIFontMetrics(forTextStyle: .title3)
         .scaledFont(for: .systemFont(ofSize: 15, weight: .light))
   }
   
   private static var headline: UIFont {
      UIFontMetrics(forTextStyle: .headline)
         .scaledFont(for: .systemFont(ofSize: 14, weight: .semibold))
   }
   private static var subheadline: UIFont {
      UIFontMetrics(forTextStyle: .headline)
         .scaledFont(for: .systemFont(ofSize: 12, weight: .light))
   }
   private static var largeTitle: UIFont {
      UIFontMetrics(forTextStyle: .largeTitle)
         .scaledFont(for: .systemFont(ofSize: 64, weight: .heavy))
   }
   private static var button: UIFont {
      UIFontMetrics(forTextStyle: .headline)
         .scaledFont(for: .systemFont(ofSize: 13, weight: .semibold))
   }
}

extension UIFont {
   enum Style {
      case title2
      case title4
      case headline
      case subheadline
      case largeTitle
      case button
   }
   
   static func custom(style: Style) -> UIFont {
      switch style {
      case .title2: return .title2
      case .title4: return .title4
      case .headline: return .headline
      case .subheadline: return .subheadline
      case .largeTitle: return .largeTitle
      case .button: return .button
      }
   }
}
