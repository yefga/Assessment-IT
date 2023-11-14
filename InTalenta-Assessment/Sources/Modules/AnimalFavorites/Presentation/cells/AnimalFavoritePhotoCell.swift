//
//  AnimalFavoritePhotoCell.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 13/11/23.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class AnimalFavoritePhotoCell: UICollectionViewCell {
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1.0
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add your view configuration code here
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any cell-specific properties or states here
    }
    
}

extension AnimalFavoritePhotoCell {
    // MARK: Custom Methods
    func updateUI(with Item: AnimalDBModel) {
        // Put any additional setup to update the UI here.
        photoImageView.kf.setImage(with: URL(string: Item.photoThumbnail ?? "")!)
    }
}
