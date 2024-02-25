//
//  ContentCell.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 22/02/24.
//

import UIKit
import Anchorage

protocol ContentConfiguringView: UIView {
    func configure(with content: Content?)
}

final class ContentCell<View: ContentConfiguringView>: UICollectionViewCell {
    private lazy var view: View = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrain()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        constrain()
    }
    func constrain() {
        contentView.addSubview(view)
        view.edgeAnchors == contentView.edgeAnchors
    }
    func configure(with content: Content?){
        view.configure(with: content)
    }
   
    static func registration() -> UICollectionView.CellRegistration<ContentCell<View>, Content> {
        UICollectionView.CellRegistration {
            cell, _, content in
            cell.configure(with: content)
        }
    }
}
