//
//  FooterCell.swift
//  Airbnb-clone
//
//  Created by Nathan Mora on 13/03/24.
//

import UIKit
import Anchorage

typealias FooterCell = ContentCell<FooterView>

class FooterView: ProgrammaticView, ContentConfiguringView {
   
   private let stack = UIStackView()
   private let titleLabel = UILabel()
   private let subtitleLabel = UILabel()
   private let separator = UIView()
   
   override func configure() {
      stack.axis = .vertical
      stack.spacing = 4
      
      titleLabel.font = .custom(style: .headline)
      subtitleLabel.font = .custom(style: .subheadline)
      
      separator.backgroundColor = .quaternaryLabel
      
   }
   override func constraint() {
      addSubviews(stack, separator)
      stack.addArrangedSubviews(titleLabel, subtitleLabel)
      stack.horizontalAnchors == horizontalAnchors
      stack.verticalAnchors == verticalAnchors + 28
      
      separator.topAnchor == bottomAnchor
      separator.horizontalAnchors == horizontalAnchors
      separator.heightAnchor == 1
   }
   
   func configure(with content: Content?) {
      titleLabel.text = content?.title
      subtitleLabel.text = content?.subtitle
      
      switch content?.style {
      case .standard:
         titleLabel.font = .custom(style: .headline)
      case .title:
         titleLabel.font = .custom(style: .title4)
      case .none:
         break
      }
   }
}

extension FooterView: SeparatorShowing {
   func showSeparator(_ shouldShow: Bool) {
      separator.alpha = shouldShow ? 0.8 : 0
   }
}
