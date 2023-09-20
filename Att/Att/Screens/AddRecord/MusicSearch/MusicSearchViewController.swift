//
//  MusicSearchViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Combine
import MusicKit
import SnapKit
import UIKit

final class MusicInfoTableViewDiffableDataSource: UITableViewDiffableDataSource<Int, MusicInfo?> { }

final class MusicSearchViewController: UIViewController {

    private var musicManager: MusicManager?
    
    private var searchSubscriber: AnyCancellable?
    private var searchText = ""
    private let debounceInterval: TimeInterval = 0.5
    
    private var recordCreationViewModel: RecordCreationViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: MusicSearchResultViewController(recordCreationViewModel: recordCreationViewModel))
        return controller
    }()
    
    init(recordCreationViewModel: RecordCreationViewModel?, musicManager: MusicManager) {
        super.init(nibName: nil, bundle: nil)
        self.musicManager = musicManager
        self.recordCreationViewModel = recordCreationViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAuthorization()
        setUpStyle()
        setUpNavigationItem()
        setUpDelegate()
        setUpSubscriber()
    }
    
    private func getAuthorization() {
        Task {
            await MusicAuthorizationManager.shared.requestMusicAuthorization()
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .black
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.title = "음악 검색"
        self.navigationItem.searchController = searchController
    }
    
    private func setUpDelegate() {
        searchController.searchBar.delegate = self
        
        if let searchResultController = searchController.searchResultsController as? MusicSearchResultViewController {
            searchResultController.delegate = self
        }
    }
    
    private func setUpSubscriber() {
        searchSubscriber = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main) // 딜레이 설정
            .map { [weak self] _ in
                self?.searchText = self?.searchController.searchBar.text ?? ""
                print(self?.searchController.searchBar.text ?? "")
                return self?.searchText
            }
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.updateSearchResults(as: searchText)
            }
    }
    
    private func updateSearchResults(as title: String?) {
        guard let title = title else { return }
        guard let resultController = searchController.searchResultsController as? MusicSearchResultViewController else { return }
        if title == "" {
            resultController.performMusicInfoTableViewCell(musicInfoList: nil)
            return
        }
        Task {
            let musicInfoList = await musicManager?.getMusicList(named: title)
            resultController.performMusicInfoTableViewCell(musicInfoList: musicInfoList)
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
