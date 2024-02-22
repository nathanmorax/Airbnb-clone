//
//  UIImage+Helpers.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//

import UIKit

extension UIImage {
    convenience init?(named name: String?) {
        guard let name = name else { return nil }
        self.init(named: name)
    }
}
