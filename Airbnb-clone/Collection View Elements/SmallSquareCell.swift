//
//  SmallSquareCell.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit
import Anchorage

typealias SmallSquareCell = ContentCell<SmallSquareView>

final class SmallSquareView: ProgrammaticView, ContentConfiguringView {
    
    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func configure() {
        imageView.backgroundColor = .secondarySystemFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        titleLabel.font = .custom(style: .headline)
        subtitleLabel.font = .custom(style: .subheadline)
        
    }
    override func constraint() {
        addSubviews(imageView, stackView)
        stackView.addArrangedSubviews(titleLabel, subtitleLabel)
        
        imageView.verticalAnchors == verticalAnchors
        imageView.leadingAnchor == leadingAnchor
        imageView.widthAnchor == imageView.heightAnchor
        
        stackView.leadingAnchor == imageView.trailingAnchor + 10
        stackView.trailingAnchor == trailingAnchor
        stackView.centerYAnchor == centerYAnchor
        
    }
    
    func configure(with content: Content?) {
        titleLabel.text = content?.title
        subtitleLabel.text = content?.subtitle
        imageView.image = UIImage(named: content?.image)
    }
    
}
