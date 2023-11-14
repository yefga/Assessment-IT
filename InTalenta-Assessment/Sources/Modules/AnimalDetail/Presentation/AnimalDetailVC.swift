//
//  AnimalDetailVC.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 14/11/23.
//

import Foundation
import ComposableArchitecture
import SnapKit
import Combine
import Kingfisher
import UIKit

class AnimalDetailVC: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    let viewStore: ViewStoreOf<AnimalDetailReducer>
    
    init(store: StoreOf<AnimalDetailReducer>) {
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .black
        return iv
    }()
    
    private lazy var photographerLabel: UILabel = {
        let label = UILabel()
        label.text = "Photographer"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            nameLabel,
            photographerLabel
        ])
        sv.axis = .vertical
        sv.spacing = 8.0
        return sv
    }()
    
    private lazy var wrapView: UIView = {
        let view = UIView()
        view.addSubview(stackView)
        view.addSubview(buttonStackView)
        urlButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        favoriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.leading.equalTo(stackView)
        }
        return view
    }()
    
    private lazy var urlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperclip")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.white), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
        return button
    }()
  
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            urlButton,
            favoriteButton
        ])
        sv.axis = .horizontal
        sv.spacing = 8.0
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        viewStore.send(.viewDidLoad)
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        let favoriteAction = UIAction { [weak self] _ in
            self?.viewStore.send(.favorite)
        }
        self.favoriteButton.addAction(favoriteAction, for: .touchUpInside)
        view.addSubview(photoImageView)
        view.addSubview(wrapView)
        photoImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.bounds.height / 2)
        }
        
        wrapView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            
        }
    }
    
    func updateUI() {
        viewStore.publisher.data.receive(on: DispatchQueue.main).sink { [weak self] value in
            if let originalImage = value?.src?.original, let url = URL(string: originalImage) {
                self?.photoImageView.kf.setImage(with: url)
            }
            
            self?.nameLabel.text = value?.alt
            self?.photographerLabel.text = "by: \(value?.photographer ?? "")"
            self?.photoImageView.backgroundColor = UIColor.hexStringToUIColor(hex: value?.avgColor ?? "#000000")
            
            let urlAction = UIAction(handler: { _ in
                if let url = URL(string: value?.url ?? "") {
                    UIApplication.shared.open(url)
                }
            })
            self?.urlButton.addAction(urlAction, for: .touchUpInside)
        }.store(in: &cancellables)
        
        viewStore.publisher.animal.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.title = value
        }.store(in: &cancellables)
        
        viewStore.publisher.isFavorite.receive(on: DispatchQueue.main).sink { [weak self] value in
            let image = UIImage(systemName: value ? "heart.fill" : "heart")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.red)
            self?.favoriteButton.setImage(image, for: .normal)
        }.store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
