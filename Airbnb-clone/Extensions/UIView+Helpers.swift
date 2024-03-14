//
//  UIView+Helpers.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit

extension UIView {
   
   func addSubviews(_ views: UIView...) {
      views.forEach{ view in addSubview(view)}
   }
   
   func setBackgroundAlpha(_ alpha: CGFloat) {
      backgroundColor = backgroundColor?.withAlphaComponent(alpha)
   }
}
