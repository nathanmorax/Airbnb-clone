//
//  BackgroundView.swift
//  Airbnb-clone
//
//  Created by Nathan Mora on 11/03/24.
//

import UIKit

class BackgroundView: UICollectionReusableView {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = provideBackgroundColor()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
      backgroundColor = provideBackgroundColor()
   }
   
   func provideBackgroundColor() -> UIColor? { nil }
}
final class InvertedBackgroundView: BackgroundView {
   override func provideBackgroundColor() -> UIColor? {
      .invertedBackground
   }
}

enum BackgroundStyle: String, CaseIterable {
   case inverted
   
   var elementKind: String { "background.\(rawValue)" }
   
   var viewClass: AnyClass {
      switch self {
      case .inverted: return InvertedBackgroundView.self
      }
   }
}

extension UICollectionViewLayout {
   func registerBackgrounds() {
      BackgroundStyle.allCases.forEach {
         register($0.viewClass, forDecorationViewOfKind: $0.elementKind)
      }
   }
}

extension NSCollectionLayoutSection {
   func addBackground(style: BackgroundStyle) {
      decorationItems.append(.background(elementKind: style.elementKind))
   }
}

