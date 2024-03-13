//
//  LargeSquareCell.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 22/02/24.
//

import UIKit
import Anchorage

typealias LargeSquareCell = ContentCell<LargeSquareView>

class LargeSquareView: ProgrammaticView, ContentConfiguringView {
   
   private lazy var style: ColorStyle = provideStyle()
   private let mainStack = UIStackView()
   private let imageView = UIImageView()
   private let labelStack = UIStackView()
   private let titleLabel = UILabel()
   private let subtitleLabel = UILabel()
   
   
   override func configure() {
      
      mainStack.axis = .vertical
      mainStack.spacing = 15
      //mainStack.backgroundColor = .brown
      
      imageView.backgroundColor = .secondarySystemFill
      imageView.layer.cornerRadius = 8
      imageView.layer.masksToBounds = true
      
      labelStack.axis = .vertical
      labelStack.spacing = 5
      //labelStack.backgroundColor = .cyan
      let textColor: UIColor = style == .inverted ? .invertedLabel: .label
      titleLabel.font = .custom(style: .headline)
      titleLabel.textColor = textColor
      
      subtitleLabel.font = .custom(style: .subheadline)
      subtitleLabel.textColor = textColor
      
   }
   
   override func constraint() {
      addSubview(mainStack)
      mainStack.addArrangedSubviews(imageView, labelStack)
      labelStack.addArrangedSubviews(titleLabel, subtitleLabel)
      
      mainStack.edgeAnchors == edgeAnchors
      imageView.widthAnchor == imageView.heightAnchor
   }
   
   func configure(with content: Content?) {
      titleLabel.text = content?.title
      subtitleLabel.text = content?.subtitle
      imageView.image = UIImage(named: content?.image)
   }
   
   func provideStyle() -> ColorStyle {
      .standard
   }
}
typealias InvertedLargeSquareCell = ContentCell<InvertedLargeSquareView>

class InvertedLargeSquareView: LargeSquareView {
   override func provideStyle() -> ColorStyle {
      .inverted
   }
}


