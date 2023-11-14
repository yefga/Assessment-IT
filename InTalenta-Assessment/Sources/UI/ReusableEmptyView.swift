//
//  ReusableEmptyView.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 08/11/23.
//

import SnapKit
import UIKit

class ReusableEmptyView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            titleLabel,
            bodyLabel
        ])
        sv.axis = .vertical
        sv.spacing = 8.0
        sv.distribution = .equalCentering
        return sv
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        // Add your view configuration code here
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReusableEmptyView {
    func updateUI(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}

