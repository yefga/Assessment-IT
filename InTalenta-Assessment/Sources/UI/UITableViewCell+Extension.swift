//
//  UITableViewCell+Extension.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 05/11/23.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

