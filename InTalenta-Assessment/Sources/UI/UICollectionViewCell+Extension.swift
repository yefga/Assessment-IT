//
//  UICollectionViewCell+Extension.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
