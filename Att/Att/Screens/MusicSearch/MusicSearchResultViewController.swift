//
//  MusicSearchResultViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import UIKit

protocol MusicSearchResultViewControllerDelegate: AnyObject {
    func dismissSearchViewController()
}

final class MusicSearchResultViewController: UIViewController {

    weak var delegate: MusicSearchResultViewControllerDelegate?
    
    private lazy var musicSearchResultTableView: UITableView = {
        let view = UITableView()
        view.contentInsetAdjustmentBehavior = .always
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private var musicInfoTableViewDiffableDataSource: MusicInfoTableViewDiffableDataSource!
    
    private var viewModel: RecordCreationViewModel?
    init(viewModel: RecordCreationViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpDelegate()
        setUpMusicSearchResultTableViewDataSource()

    }

    private func setUpConstraints() {
        view.addSubview(musicSearchResultTableView)
        musicSearchResultTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpDelegate() {
        musicSearchResultTableView.delegate = self
    }
    
    private func setUpMusicSearchResultTableViewDataSource() {
        musicSearchResultTableView.register(MusicInfoTableViewCell.self, forCellReuseIdentifier: MusicInfoTableViewCell.identifier)
        musicSearchResultTableView.dataSource = musicInfoTableViewDiffableDataSource
        
        musicInfoTableViewDiffableDataSource = MusicInfoTableViewDiffableDataSource(tableView: musicSearchResultTableView) { (tableView, indexPath, info) ->
            MusicInfoTableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicInfoTableViewCell.identifier, for: indexPath) as? MusicInfoTableViewCell else {
                return MusicInfoTableViewCell()
            }
            
            cell.setUpComponent(info: info)
            return cell
        }
    }
    
    func performMusicInfoTableViewCell(musicInfoList: [MusicInfo]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MusicInfo?>()
        snapshot.appendSections([0])
        if let musicInfoList = musicInfoList {
            snapshot.appendItems(musicInfoList)
        }
        musicInfoTableViewDiffableDataSource.apply(snapshot)
    }
}

extension MusicSearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return musicInfoTableViewDiffableDataSource.accessibilityElementCount()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MusicInfoTableViewCell else { return }
        viewModel?.setMusicInfo(musicInfo: cell.getMusicInfo())
        delegate?.dismissSearchViewController()
    }
}
