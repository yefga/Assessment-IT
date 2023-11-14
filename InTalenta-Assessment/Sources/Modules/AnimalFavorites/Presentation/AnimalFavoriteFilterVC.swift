//
//  AnimalFavoriteFilterVC.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 14/11/23.
//

import Foundation
import UIKit
import SnapKit
import Combine
import ComposableArchitecture

struct AnimalFavoriteFilterModel: Equatable, Hashable {
    let name: String
    var isSelected: Bool = false
}

class AnimalFavoriteFilterVC: UIViewController {

    var didTapApply: (([AnimalFavoriteFilterModel]) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    let viewStore: ViewStoreOf<AnimalFavoriteFilterReducer>

    init(store: StoreOf<AnimalFavoriteFilterReducer>) {
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.text = "Filter By Animal"
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(AnimalFavoriteFilterCell.self, forCellReuseIdentifier: AnimalFavoriteFilterCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 55
        return tv
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.didTapApply?(self?.viewStore.animals ?? [])
            }
        }
        button.layer.cornerRadius = 8.0
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        viewStore.send(.viewDidLoad)
    }
    
}

extension AnimalFavoriteFilterVC {
    
    // MARK: Custom Methods
    func setupUI() {
        // Add your viewController configuration code here
        self.view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(filterButton)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
    
    func updateUI() {
        viewStore.publisher.animals.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
}

// MARK: - UITableViewDelegate
extension AnimalFavoriteFilterVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension AnimalFavoriteFilterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewStore.animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AnimalFavoriteFilterCell.reuseIdentifier,
            for: indexPath
        ) as? AnimalFavoriteFilterCell else {
            return UITableViewCell()
        }
        let animal = viewStore.animals[indexPath.row]
        cell.updateUI(with: animal.name, isSelected: animal.isSelected)
        cell.filterSelected = { [weak self] isEnabled in
            self?.viewStore.send(.filter(indexPath.row, isEnabled))
        }
        return cell
    }
}

