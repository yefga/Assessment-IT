//
//  AnimalSearchVC.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 04/11/23.
//

import UIKit
import SnapKit
import ComposableArchitecture
import Combine

class AnimalSearchVC: ReusableTableViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.delegate = self
        sb.showsCancelButton = false
        sb.placeholder = "Search for animal here..."
        return sb
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        let action = UIAction { [weak self] _ in
            self?.viewStore.send(.refresh)
        }
        rc.addAction(action, for: .valueChanged)
        return rc
    }()
    
    let textSubject = PassthroughSubject<String, Never>()
    let viewStore: ViewStoreOf<AnimalReducer>
    
    // MARK: Initialization
    init(
        store: StoreOf<AnimalReducer>
    ) {
        self.viewStore = ViewStore(store, observe: {$0})
        super.init(nibName: nil, bundle: nil)
    }
    
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

extension AnimalSearchVC {
    
    // MARK: Custom Methods
    func setupUI() {
        // Add your viewController configuration code here
        self.navigationController?.navigationItem.title = "Search Animal"
        self.navigationItem.titleView = searchBar
        self.view.backgroundColor = .white
        self.tableView.register(AnimalSearchCell.self, forCellReuseIdentifier: AnimalSearchCell.reuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = self.refreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
    }
    
    func updateUI() {
        
        viewStore.publisher.animals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
        
        viewStore.publisher
            .viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .refresh:
                    self?.refreshControl.beginRefreshing()
                case .loading:
                    self?.tableView.backgroundView = ReusableLoadingView()
                case .success(let empty):
                    self?.refreshControl.endRefreshing()
                    if empty {
                        let emptyView = ReusableEmptyView()
                        emptyView.updateUI(
                            title: "No Result",
                            body: "Sorry, there is no result, Maybe you can try another keyword"
                        )
                        self?.tableView.backgroundView = emptyView
                    } else {
                        self?.tableView.backgroundView = nil
                    }
                default: break
                    
                }
        }.store(in: &cancellables)
    }
    
}

// MARK: - UITableViewDelegate
extension AnimalSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, 
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        let animal = viewStore.animals[indexPath.row]
        let vc = AnimalPhotosVC(
            store: .init(
                initialState: AnimalPhotosReducer.State(animal: animal),
                reducer: { AnimalPhotosReducer() }
            )
        )
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
//        vc.hidesBottomBarWhenPushed = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AnimalSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewStore.animals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AnimalSearchCell.reuseIdentifier,
            for: indexPath
        ) as? AnimalSearchCell else {
            return UITableViewCell()
        }
        
        let animal = viewStore.animals[indexPath.row]
        cell.updateUI(with: animal)
        if indexPath.row == viewStore.animals.count-1 {
            cell.hideSeparator()
        }
        return cell
    }
}

extension AnimalSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewStore.send(.searchAnimal(searchBar.text ?? ""))
    }
}
