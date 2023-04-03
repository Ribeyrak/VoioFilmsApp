//
//  FilmListVC.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 29.03.2023.
//

import Combine
import CombineCocoa
import UIKit

class FilmsListVC: UIViewController {
    
    //MARK: - Constants
    private enum Constants {
        static let title = "Find Movies"
        static let collectioViewPrefetchOffset = 4
        static let searchPlaceholderText = "Search"
    }
    
    // MARK: - UI
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionLayout())
        collectionView.register(FilmCollectionViewCell.self,
                                forCellWithReuseIdentifier: FilmCollectionViewCell.idealReuseIdentifier)
        collectionView.register(FilterCollectionViewCell.self,
                                forCellWithReuseIdentifier: FilterCollectionViewCell.idealReuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
//    private(set) var activityIndicator = UIActivityIndicatorView().then {
//        $0.style = .large
//        $0.color = .black
//    }
//
//    private let emptyResultsLabel = UILabel().then {
//        $0.isHidden = true
//        $0.text = "No Films Found"
//        $0.font = .preferredFont(forTextStyle: .subheadline)
//        $0.textColor = .tertiaryLabel
//    }
//
    private var searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.enablesReturnKeyAutomatically = false
        $0.placeholder = Constants.searchPlaceholderText
    }
    
    // MARK: - Propertiest
    private let viewModel = FilmListVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Livecycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        bindUI()
    }
    
    // MARK: - Private functions
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.title
        navigationController?.tabBarItem.title = TabBar.title(for: .main)
    }
    
    private func setupUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        contentView.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        //definesPresentationContext = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self

        let films = viewModel.$films
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .share()

        films
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        searchBar.textDidChangePublisher
            .removeDuplicates()
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .assign(to: &viewModel.$searchText)
        
        searchBar.text = "With"
        viewModel.searchText = "with"
    }
    
    private func createCollectionLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self]
            (sectionIndex: Int,
             layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let strongSelf = self else {
                return nil
            }
            
            let group: NSCollectionLayoutGroup = {
               sectionIndex == 0
                ? strongSelf.createFiltersGroup()
                : strongSelf.createFilmGroup()
            }()

            let section = NSCollectionLayoutSection(group: group)
            if sectionIndex == 0 {
                section.orthogonalScrollingBehavior = .continuous
            }
            return section
        }

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider
        )
        return layout
    }
    
    
    private func createFilmGroup() -> NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
    
    private func createFiltersGroup() -> NSCollectionLayoutGroup {
        let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemsSize)
        item.contentInsets = .init(top: 2, leading: 6, bottom: 2, trailing: 2)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
    
    private func loadMoreIfNeeded(indexPaths: [IndexPath]) {
        if indexPaths.contains(where: {
            $0.row > collectionView.numberOfItems(inSection: 1) - Constants.collectioViewPrefetchOffset
        }) {
            viewModel.fetchNextPage()
        }
    }

}

extension FilmsListVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? viewModel.filterSettings.count : viewModel.films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withClass: FilterCollectionViewCell.self, for: indexPath)
            cell.title.text = viewModel.filterSettings[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withClass: FilmCollectionViewCell.self, for: indexPath)
        cell.setup(with: viewModel.films[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension FilmsListVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        loadMoreIfNeeded(indexPaths: indexPaths)
    }
}

//MARK: - UICollectionViewDelegate
extension FilmsListVC: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.searchText = viewModel.filterSettings[indexPath.row]
            searchBar.text = viewModel.filterSettings[indexPath.row]
        } else {
            let detailVC = DetailsFilmVC(film: viewModel.films[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            self.makeContextMenu(for: indexPath)
        })
    }
    
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        var menuActions = [UIAction]()
        let action1 = UIAction(title: "Like", image: UIImage(systemName: "hand.thumbsup.fill")) { [weak self] _ in
            guard let self = self else { return }
            print("film was add to favorite")
    
        }
        let action2 = UIAction(title: "Unlike", image: UIImage(systemName: "hand.thumbsup")) { [weak self] _ in
            print("film was delete from favorite")

        }
        menuActions.append(action1)
        menuActions.append(action2)

        return UIMenu(title: "Custome name", children: menuActions)
    }

}
