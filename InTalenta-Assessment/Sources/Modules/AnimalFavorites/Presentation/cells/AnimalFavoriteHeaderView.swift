//
//  AnimalFavoriteHeaderView.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 14/11/23.
//

import Foundation
import UIKit
import SnapKit

class AnimalFavoriteHeaderView: UICollectionReusableView {
    // Add a label to the header view
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    // Override the initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add the label to the header view
        addSubview(titleLabel)

        // Set up constraints for the label
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(text: String) {
        titleLabel.text = text
    }
}
