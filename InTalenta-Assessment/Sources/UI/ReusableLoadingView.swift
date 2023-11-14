//
//  ReusableLoadingView.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 13/11/23.
//

import Foundation
import UIKit
import SnapKit

class ReusableLoadingView: UIView {
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.startAnimating()
        return ai
    }()
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.text = "Loading"
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [indicatorView, label])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 10.0
        sv.backgroundColor = .white
        return sv
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        // Add your view configuration code here
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Initialization (Storyboard / XIB)
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

