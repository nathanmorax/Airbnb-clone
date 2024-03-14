//
//  ViewController.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit

class HomeViewController: UIViewController {
   
   private lazy var contentView: HomeView = .init()
   private var statusBarStyle: UIStatusBarStyle = .lightContent
   
   override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }
   
   override func loadView() {
      view = contentView
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      updateList()
   }
   
   private func updateList() {
      var snapshot = NSDiffableDataSourceSnapshot<Section, Content>()
      
      snapshot.appendSections(Section.allCases)
      Section.allCases.forEach {
         snapshot.appendItems($0.stubData(), toSection: $0)
      }
      contentView.apply(snapshot)
   }
}

