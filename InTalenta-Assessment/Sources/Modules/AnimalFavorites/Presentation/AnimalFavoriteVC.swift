//
//  AnimalFavoriteVC.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation
import UIKit
import SnapKit
import Combine
import ComposableArchitecture
import FittedSheets

class AnimalFavoriteVC: UIViewController {
        
    private var cancellables = Set<AnyCancellable>()
    let viewStore: ViewStoreOf<AnimalFavoriteReducer>
    
    init(store: StoreOf<AnimalFavoriteReducer>) {
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds.width / 3
        layout.itemSize = .init(width: size, height: size)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, 
                                  collectionViewLayout: collectionViewLayout)
        cv.register(AnimalFavoritePhotoCell.self,
                    forCellWithReuseIdentifier: AnimalFavoritePhotoCell.reuseIdentifier)
        cv.register(AnimalFavoriteHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "AnimalFavoriteHeaderView")

        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = refreshControl
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        let action = UIAction { [weak self] _ in
            self?.viewStore.send(.refresh)
        }
        rc.addAction(action, for: .valueChanged)
        return rc
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewStore.send(.viewWillAppear)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
}

extension AnimalFavoriteVC {
    
    // MARK: Custom Methods
    func setupUI() {
        self.title = "Favorite"
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigation() {
        let resetAction = UIAction { [weak self] _ in
            self?.viewStore.send(.fetchPhotos)
        }
        
        let resetButton = UIBarButtonItem.init(image: UIImage(systemName: "arrow.clockwise"),
                                               primaryAction: resetAction)
        // Add your viewController configuration code here
        let filterAction = UIAction { [weak self] _ in
            let controller = AnimalFavoriteFilterVC(
                store: .init(initialState: AnimalFavoriteFilterReducer.State(animals: self?.viewStore.setAnimal ?? []),
                             reducer: { AnimalFavoriteFilterReducer() })
            )
            controller.didTapApply = { [weak self] preferences in
                self?.viewStore.send(.filter(preferences))
            }
            let options = SheetOptions(
                pullBarHeight: 24,
                presentingViewCornerRadius: 20,
                shouldExtendBackground: true,
                setIntrinsicHeightOnNavigationControllers: true,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                useInlineMode: false,
                horizontalPadding: 0,
                maxWidth: nil
            )
            
            let sheetViewController = SheetViewController(controller: controller,
                                                          sizes: [.percent(0.5), .intrinsic],
                                                          options: options)
            self?.present(sheetViewController, animated: true)
        }
        
        let filterButton = UIBarButtonItem(title: "Filter",
                                           primaryAction: filterAction)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [filterButton, resetButton]
    }
    
    func updateUI() {
        viewStore.publisher.photos.receive(on: DispatchQueue.main).sink { [weak self] photos in
            self?.collectionView.reloadData()
            if !photos.isEmpty {
                self?.setupNavigation()
            }
        }.store(in: &cancellables)
        
        viewStore.publisher.viewState.receive(on: DispatchQueue.main).sink { [weak self] value in
            switch value {
            case .loading:
                self?.collectionView.backgroundView = ReusableLoadingView()
                
            case .refresh:
                self?.refreshControl.beginRefreshing()
                
            case .success(let empty):
                self?.refreshControl.endRefreshing()
                if empty {
                    let emptyView = ReusableEmptyView()
                    emptyView.updateUI(
                        title: "No Data",
                        body: "There is no photo in your favorite"
                    )
                    self?.collectionView.backgroundView = emptyView
                } else {
                    self?.collectionView.backgroundView = nil
                }
            
            default:
                break;
            }
        }.store(in: &cancellables)

    }
    
}

// MARK: - UICollectionViewDelegate
extension AnimalFavoriteVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "AnimalFavoriteHeaderView",
            for: indexPath) as? AnimalFavoriteHeaderView,
           kind == UICollectionView.elementKindSectionHeader {
            header.updateUI(text: viewStore.titleLabel)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewStore.photos[indexPath.item]
        let id = photo.photoID ?? "0"
        let vc = AnimalDetailVC(
            store: .init(
                initialState: AnimalDetailReducer.State(
                    id: id,
                    animal: photo.category ?? "",
                    isFavorite: true
                ),
                reducer: { AnimalDetailReducer()
                }
            )
        )
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        vc.hidesBottomBarWhenPushed = false
    }
}

extension AnimalFavoriteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: self.view.bounds.width, height: 48)
    }
}
// MARK: - UICollectionViewDataSource
extension AnimalFavoriteVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        viewStore.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AnimalFavoritePhotoCell.reuseIdentifier,
            for: indexPath
        ) as? AnimalFavoritePhotoCell else {
            return UICollectionViewCell()
        }
        cell.updateUI(with: viewStore.photos[indexPath.item])
        
        return cell
    }
    
}

