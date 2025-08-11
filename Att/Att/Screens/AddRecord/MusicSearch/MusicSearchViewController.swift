//
//  MusicSearchViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Combine
import SnapKit
import UIKit

final class MusicInfoTableViewDiffableDataSource: UITableViewDiffableDataSource<Int, MusicInfo> { }

final class MusicSearchViewController: UIViewController {

    private let searchViewModel: SearchViewModel
    private var recordCreationViewModel: RecordCreationViewModel?

    private var searchSubscriber: AnyCancellable?
    private let debounceInterval: TimeInterval = 0.5

    private lazy var searchController: UISearchController = {
        let resultsVC = MusicSearchResultViewController(recordCreationViewModel: recordCreationViewModel)
        let controller = UISearchController(searchResultsController: resultsVC)
        controller.searchBar.tintColor = .green
        return controller
    }()

    init(searchViewModel: SearchViewModel, recordCreationViewModel: RecordCreationViewModel?) {
        self.searchViewModel = searchViewModel
        self.recordCreationViewModel = recordCreationViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        getAuthorizationIfNeeded()
        setUpStyle()
        setUpNavigationItem()
        setUpDelegate()
        setUpSubscriber()
    }

    private func getAuthorizationIfNeeded() {
        Task { await MusicAuthorizationManager.shared.requestIfNeeded() }
    }

    private func setUpStyle() {
        view.backgroundColor = .black
    }

    private func setUpNavigationItem() {
        navigationItem.title = "음악 검색"
        navigationItem.searchController = searchController
    }

    private func setUpDelegate() {
        searchController.searchBar.delegate = self

        if let resultsVC = searchController.searchResultsController as? MusicSearchResultViewController {
            resultsVC.delegate = self
            // 결과 셀에서 artwork 필요하면 resultsVC가 vm.loadArtwork(for:)를 호출하도록 바인딩
            resultsVC.bind(viewModel: searchViewModel)
        }
    }

    private func setUpSubscriber() {
        searchSubscriber = NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification,
                       object: searchController.searchBar.searchTextField)
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.searchController.searchBar.text }
            .removeDuplicates()
            .sink { [weak self] text in
                self?.updateSearchResults(as: text)
            }
    }

    private func updateSearchResults(as title: String?) {
        guard let title,
              let resultsVC = searchController.searchResultsController as? MusicSearchResultViewController
        else { return }

        if title.isEmpty {
            resultsVC.render(items: [])
            return
        }

        Task {
            await searchViewModel.search(term: title)
            resultsVC.render(items: searchViewModel.results)
        }
    }
}

extension MusicSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MusicSearchViewController: MusicSearchResultViewControllerDelegate {
    func dismissSearchViewController() {
        navigationController?.dismiss(animated: true)
    }
}
