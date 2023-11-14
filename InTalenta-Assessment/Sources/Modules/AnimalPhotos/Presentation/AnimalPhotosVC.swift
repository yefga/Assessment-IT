//
//  AnimalPhotosVC.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation
import UIKit
import SnapKit
import Combine
import ComposableArchitecture

class AnimalPhotosVC: UIViewController {
    
    public var cancellables: Set<AnyCancellable> = []
    let viewStore: ViewStore<AnimalPhotosReducer.State, AnimalPhotosReducer.Action>
    
    init(store: StoreOf<AnimalPhotosReducer>) {
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        let action = UIAction { [weak self] _ in
            self?.viewStore.send(.refresh)
        }
        rc.addAction(action, for: .valueChanged)
        return rc
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemSize = self.view.bounds.width / 2 - 24
        layout.itemSize = .init(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, 
                                  collectionViewLayout: collectionViewLayout)
        cv.backgroundColor = .white
        cv.register(AnimalPhotoCell.self, 
                    forCellWithReuseIdentifier: AnimalPhotoCell.reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = refreshControl
        return cv
    }()
    
    private lazy var moreIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.stopAnimating()
        ai.hidesWhenStopped = true
        return ai
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewStore.send(.viewWillAppear)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        viewStore.send(.viewDidLoad)
    }
    
}

extension AnimalPhotosVC {
    
    // MARK: Custom Methods
    func setupUI() {
        // Add your viewController configuration code here
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(moreIndicatorView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        moreIndicatorView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets.bottom).offset(-16)
            make.centerX.equalToSuperview()
        }
    }
    
    func updateUI() {
        viewStore.publisher
            .title
            .receive(on: DispatchQueue.main)
            .sink { animal in
                self.title = animal
            }.store(in: &cancellables)
        
        viewStore.publisher.photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.collectionView.reloadData()
        }.store(in: &cancellables)
        
        viewStore.publisher.viewState.receive(on: DispatchQueue.main).sink { [weak self] value in
            switch value {
            case .more:
                self?.moreIndicatorView.startAnimating()
            case .loading:
                self?.collectionView.backgroundView = ReusableLoadingView()
            case .refresh:
                self?.refreshControl.beginRefreshing()
            case .success(let empty):
                self?.refreshControl.endRefreshing()
                self?.moreIndicatorView.stopAnimating()
                if empty {
                    let emptyView = ReusableEmptyView()
                    emptyView.updateUI(
                        title: "No Result",
                        body: "Sorry, there is no result, Maybe you can try another keyword"
                    )
                    self?.collectionView.backgroundView = emptyView
                } else {
                    self?.collectionView.backgroundView = nil
                }
            default:
                self?.refreshControl.endRefreshing()
                self?.moreIndicatorView.stopAnimating()
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: - UICollectionViewDelegate
extension AnimalPhotosVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let photo = viewStore.photos[indexPath.item]
        let id = String(photo.id ?? 0)
        let vc = AnimalDetailVC(
            store: .init(
                initialState: AnimalDetailReducer.State(
                    id: id,
                    animal: viewStore.animal,
                    isFavorite: photo.isFavorite
                ),
                reducer: { AnimalDetailReducer()
                }
            )
        )
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewStore.photos.count-1) {
            viewStore.send(.loadMore)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AnimalPhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        viewStore.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AnimalPhotoCell.reuseIdentifier,
            for: indexPath
        ) as? AnimalPhotoCell else {
            return UICollectionViewCell()
        }
        
        switch viewStore.viewState {
        case .success, .more:
            let photo = viewStore.photos[indexPath.item]
            cell.updateUI(
                with: photo
            )
            cell.favoriteAction = { [weak self] in
                self?.viewStore.send(.favorite(index: indexPath.item))
                collectionView.reloadItems(at: [indexPath])
            }
            return cell

        default:
            return UICollectionViewCell()
        }
        
    }
    
}
