//
//  AnimalPhotosCell.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import UIKit
import SnapKit
import Kingfisher

class AnimalPhotoCell: UICollectionViewCell {
    
    var favoriteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateUI()
    }
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10.0
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var favoriteButton: ReusableCheckButton = {
        let button = ReusableCheckButton()
        button.selectedImage = UIImage(systemName: "heart.fill")?.withTintColor(.red)
        button.unselectedImage = UIImage(systemName: "heart")?.withTintColor(.red)
        let favoriteAction = UIAction(handler: { [weak self] _ in
            self?.favoriteAction?()
        })
        
        button.addAction(favoriteAction, for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add your view configuration code here
        self.addSubview(photoImageView)
        self.addSubview(favoriteButton)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.top.trailing.equalToSuperview().inset(8)
        }
        
    }
    
    private func updateUI() {
    }
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization to load object from storyboard or nib file.
    }
    
    // MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any cell-specific properties or states here
    }
    
}

extension AnimalPhotoCell {
    // MARK: Custom Methods
    func updateUI(with photo: PhotoModel?) {
        let urlString = photo?.src?.tiny ?? ""
               
        self.photoImageView.kf.setImage(
            with: URL(string: urlString)!,
            placeholder: UIImage(systemName: "pawprint.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        )
        self.favoriteButton.isSelected = photo?.isFavorite ?? false
    }
}
