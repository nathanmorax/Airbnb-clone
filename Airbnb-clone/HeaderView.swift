//
//  HeaderView.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit
import Anchorage

class HeaderView: ProgrammaticView {
    override func configure() {
        backgroundColor = .systemTeal
    }
    
    override func constraint() {
        heightAnchor == 80
    }
}
