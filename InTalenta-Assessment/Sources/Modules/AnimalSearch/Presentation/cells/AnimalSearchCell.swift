//
//  AnimalSearchCell.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 04/11/23.
//

import SnapKit
import UIKit

class AnimalSearchCell: UITableViewCell {
    
    
    private lazy var animalLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let vw = UIView()
        vw.backgroundColor = .black.withAlphaComponent(0.1)
        return vw
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add your view configuration code here
        self.addSubview(animalLabel)
        self.addSubview(separatorView)
        self.animalLabel.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview().inset(16)
        }
        
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-1)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - setSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}

extension AnimalSearchCell {
    // MARK: - Custom Methods
    func updateUI(with Item: String) {
        // Put any additional setup to update the UI here.
        self.animalLabel.text = Item
    }
    
    func hideSeparator() {
        separatorView.removeFromSuperview()
    }
}

