//
//  RecordBrowseViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

final class RecordBrowseViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = .caption
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .largeTitle
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    private lazy var publicationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()

    private lazy var todaysMoodView: TodaysMoodView = {
        let view = TodaysMoodView(title: "Today's Mood")
        return view
    }()
    
    private lazy var nowPlayingView: NowPlayingView = {
        let view = NowPlayingView(title: "Now Playing")
        return view
    }()
    
    private lazy var ticketDecorationView: TicketDecorationView = {
        let view = TicketDecorationView()
        return view
    }()
    
    private lazy var fromYesterdayView: FromYesterdayView = {
        let view = FromYesterdayView(title: "From Yesterday")
        return view
    }()
    
    private lazy var diaryView: DiaryView = {
        let view = DiaryView(title: "오늘의 일기")
        return view
    }()
    
    private lazy var toTomorrowView: ToTomorrowView = {
        let view = ToTomorrowView(title: "내일의 나에게")
        return view
    }()
    
    // TEST
    private var viewModel: DateViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DateViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }

    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpAction()
        bind()
    }
    
    private func setUpConstriants() {
        
        let constraints = Constraints.shared
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        [
            editButton,
            dateLabel,
            publicationTimeLabel,
            todaysMoodView,
            nowPlayingView,
            ticketDecorationView,
            fromYesterdayView,
            diaryView,
            toTomorrowView
        ].forEach {
            contentView.addSubview($0)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space22)
            make.trailing.equalToSuperview().inset(constraints.space26)
            make.width.equalTo(60)
            make.height.equalTo(22)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(constraints.space24)
            make.trailing.equalTo(editButton)
            make.width.equalTo(240)
            make.height.equalTo(36)
        }
        
        publicationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(constraints.space4)
            make.trailing.equalTo(editButton)
            make.width.equalTo(240)
            make.height.equalTo(20)
        }
        
        todaysMoodView.snp.makeConstraints { make in
            make.top.equalTo(publicationTimeLabel.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }
        
        nowPlayingView.snp.makeConstraints { make in
            make.top.equalTo(todaysMoodView.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(96)
        }
        
        ticketDecorationView.snp.makeConstraints { make in
            make.top.equalTo(nowPlayingView.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        fromYesterdayView.snp.makeConstraints { make in
            make.top.equalTo(ticketDecorationView.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview().inset(constraints.space20)
            make.height.equalTo(100)
        }
        
        diaryView.snp.makeConstraints { make in
            make.top.equalTo(fromYesterdayView.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        
        toTomorrowView.snp.makeConstraints { make in
            make.top.equalTo(diaryView.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .white
    }
    
    // MARK: TabPulisher etc - Optional
    private func setUpAction() { }
    
    private func bind() {
        viewModel?.$currentDailyRecord
            .sink { [weak self] record in
                guard let moodColor = record?.mood?.moodColor else { return }
                self?.dateLabel.text = record?.date.date()
                self?.publicationTimeLabel.text = record?.date.publicationDate()
                self?.todaysMoodView.setUpColor(color: moodColor)
//                self?.nowPlayingView.setUpComponent(musicInfo: record?.musicInfo)
                self?.ticketDecorationView.setUpLineColor(color: moodColor)
                self?.diaryView.setUpComponent(color: moodColor, content: record?.diary)
                self?.toTomorrowView.setUpComponent(text: record?.phraseToTomorrow)
            }.store(in: &cancellables)
        
        viewModel?.$currentPhraseFromYesterday
            .sink { [weak self] phrase in
                self?.fromYesterdayView.setUpComponent(text: phrase)
            }.store(in: &cancellables)
    }
}
