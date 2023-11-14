//
//  ReusableCheckButton.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation
import UIKit

public class ReusableCheckButton: UIButton {
    
    var selectedImage: UIImage? {
        didSet {
            self.setBackgroundImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .selected)
        }
    }
    
    var unselectedImage: UIImage? {
        didSet {
            self.setBackgroundImage(unselectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

