//
//  ProgrammaticView.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit

class ProgrammaticView: UIView {
    
    @available(*, unavailable, message: "Dont use init(coder:), override init(frame:) instead")
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        constraint()
    }
    
    func configure() {}
    func constraint() {}
    
    
}
