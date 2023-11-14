//
//  AnimalFavoriteFilterCell.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 14/11/23.
//

import Foundation
import UIKit
import SnapKit

struct FavoriteFilterPreferences {
    
    enum FilterPreferences {
        case all
        case custom(String)
    }
    
    static var selectedFilter: FilterPreferences = .all
}


class AnimalFavoriteFilterCell: UITableViewCell {
    
    var filterSelected: ((Bool) -> Void)?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var checkMarkButton: ReusableCheckButton = {
        let rcb = ReusableCheckButton()
        rcb.selectedImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.black)
        rcb.unselectedImage = UIImage(systemName: "circle")?.withTintColor(.black)
        return rcb
    }()
    
    private lazy var overlayButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            self?.checkMarkButton.isSelected.toggle()
            self?.filterSelected?(self?.checkMarkButton.isSelected ?? false)
        }
        
        button.addAction(action, for: .touchUpInside)
        return button
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(checkMarkButton)
        contentView.addSubview(overlayButton)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        checkMarkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        overlayButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

extension AnimalFavoriteFilterCell {
    // MARK: - Custom Methods
    func updateUI(with Item: String, isSelected: Bool) {
        // Put any additional setup to update the UI here.
        nameLabel.text = Item
        checkMarkButton.isSelected = isSelected
    }
    
}

