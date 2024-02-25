//
//  LargeSquareCell.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 22/02/24.
//

import UIKit
import Anchorage

typealias LargeSquareCell = ContentCell

class LargeSquareView: ProgrammaticView, ContentConfiguringView {
 
    private let mainStack = UIStackView()
    private let imageView = UIImageView()
    private let labelStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    
    override func configure() {
        
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.backgroundColor = .brown
        
        imageView.backgroundColor = .secondarySystemFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        labelStack.axis = .vertical
        labelStack.spacing = 5
        labelStack.backgroundColor = .cyan
        
        titleLabel.font = .custom(style: .headline)
        titleLabel.textColor = .label
        
        subtitleLabel.font = .custom(style: .subheadline)
        subtitleLabel.textColor = .label
        
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
}

