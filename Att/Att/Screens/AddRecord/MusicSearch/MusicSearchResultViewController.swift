//
//  MusicSearchResultViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import UIKit
import SnapKit

protocol MusicSearchResultViewControllerDelegate: AnyObject {
    func dismissSearchViewController()
}

final class MusicSearchResultViewController: UIViewController {

    weak var delegate: MusicSearchResultViewControllerDelegate?

    private var viewModel: SearchViewModel?
    
    func bind(viewModel: SearchViewModel) { self.viewModel = viewModel }

    private lazy var musicSearchResultTableView: UITableView = {
        let view = UITableView()
        view.contentInsetAdjustmentBehavior = .always
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private var musicInfoTableViewDiffableDataSource: MusicInfoTableViewDiffableDataSource!

    private var recordCreationViewModel: RecordCreationViewModel?

    init(recordCreationViewModel: RecordCreationViewModel?) {
        self.recordCreationViewModel = recordCreationViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

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
        musicSearchResultTableView.register(MusicInfoTableViewCell.self,
                                            forCellReuseIdentifier: MusicInfoTableViewCell.identifier)

        // dataSource 할당 순서 주의: 생성 후 tableView.dataSource에 넣기
        musicInfoTableViewDiffableDataSource = MusicInfoTableViewDiffableDataSource(
            tableView: musicSearchResultTableView
        ) { [weak self] tableView, indexPath, info in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MusicInfoTableViewCell.identifier,
                for: indexPath
            ) as? MusicInfoTableViewCell else { return MusicInfoTableViewCell() }

            // 1) 텍스트/메타 즉시 설정
            cell.setUpComponent(info: info)

            // 2) 이미지는 초기화(placeholder) 후 비동기 로드
            cell.setArtworkImage(nil) // <- 셀 재사용 대비로 초기화

            // 3) VM 통해 URL 기반 로딩 (재사용 안전하게 indexPath 체크)
            if let viewModel = self?.viewModel {
                Task { [weak cell] in
                    let image = await viewModel.loadArtwork(for: info)
                    // 셀 재사용으로 인한 이미지 꼬임 방지
                    if let cell, tableView.indexPath(for: cell) == indexPath {
                        cell.setArtworkImage(image)
                    }
                }
            }
            return cell
        }

        musicSearchResultTableView.dataSource = musicInfoTableViewDiffableDataSource
    }

    // MARK: - Render API (외부에서 결과 바인딩)
    func render(items: [MusicInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MusicInfo>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        musicInfoTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension MusicSearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicInfoTableViewDiffableDataSource.accessibilityElementCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let info = musicInfoTableViewDiffableDataSource.itemIdentifier(for: indexPath) {
            recordCreationViewModel?.setMusicInfo(musicInfo: info)
            delegate?.dismissSearchViewController()
        }
    }
}
