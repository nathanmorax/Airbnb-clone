//
//  UITextView+Helpers.swift
//  Airbnb-clone
//
//  Created by Nathan Mora on 13/03/24.
//

import UIKit

extension UITextView {
   func setLineHeightMultiple(to lineHeightMultiple: CGFloat = 0.0) {
      
      let paraghaphStyle = NSMutableParagraphStyle()
      paraghaphStyle.lineHeightMultiple = lineHeightMultiple
      
      let attributedString: NSMutableAttributedString
      if let attributedText = attributedText {
         attributedString = NSMutableAttributedString(attributedString: attributedText)
         
      } else if let text = text {
         attributedString = NSMutableAttributedString(string: text)
      } else {
         return
      }
      
      attributedString.addAttribute(.paragraphStyle, value: paraghaphStyle, range: NSMakeRange(0, attributedString.length))
      
      attributedText = attributedString
      
   }
}
