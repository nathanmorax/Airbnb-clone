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

protocol SeparatorShowing: AnyObject {
   func showSeparator(_ shouldShow: Bool)
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
   
   static func registration(showSeparator: @escaping(IndexPath) -> Bool = { _ in false }) -> UICollectionView.CellRegistration<ContentCell<View>, Content> {
      UICollectionView.CellRegistration {
         cell, indexPath, content in
         cell.configure(with: content)
         if let cell = cell as? SeparatorShowing {
            let shouldShow = showSeparator(indexPath)
            cell.showSeparator(shouldShow)
         }
      }
   }
}

extension ContentCell: SeparatorShowing where View: SeparatorShowing {
   func showSeparator(_ shouldShow: Bool) {
      view.showSeparator(shouldShow)
   }
   
}
