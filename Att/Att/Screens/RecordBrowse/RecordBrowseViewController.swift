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

enum RecordBrowseMode {
    case read
    case create
}

final class RecordBrowseViewController: UIViewController {

    private let previewPlayer: AudioPreviewPlayer
    private var currentPreviewURL: URL?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
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
        let view = NowPlayingView(title: "Now Playing", imageLoader: DefaultImageLoader())
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
    
    private lazy var bottomFadeView = GradientFadeView()
    
    private lazy var confirmButton: NextButton = {
        let button = NextButton(title: "확인")
        return button
    }()
    
    private var dailyRecordViewModel: DailyRecordViewModel?
    private var recordCreationViewModel: RecordCreationViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var recordBrowseMode: RecordBrowseMode?
    
    init(dailyRecordViewModel: DailyRecordViewModel?,
         previewPlayer: AudioPreviewPlayer = DefaultAudioPreviewPlayer()) {
        self.dailyRecordViewModel = dailyRecordViewModel
        self.previewPlayer = previewPlayer
        self.recordBrowseMode = .read
        super.init(nibName: nil, bundle: nil)
    }
    
    init(recordCreationViewModel: RecordCreationViewModel?,
         previewPlayer: AudioPreviewPlayer = DefaultAudioPreviewPlayer()) {
        self.recordCreationViewModel = recordCreationViewModel
        self.previewPlayer = previewPlayer
        self.recordBrowseMode = .create
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        previewPlayer.stop()
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
        }
        
        [
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
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraints.space24)
            make.trailing.equalToSuperview().inset(constraints.space26)
            make.width.equalTo(240)
            make.height.equalTo(36)
        }
        
        publicationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(constraints.space4)
            make.trailing.equalTo(dateLabel)
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
            make.height.greaterThanOrEqualTo(180)
        }
        
        toTomorrowView.snp.makeConstraints { make in
            make.top.equalTo(diaryView.snp.bottom).offset(constraints.space22)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        switch recordBrowseMode {
        case .read:
            toTomorrowView.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
            
            scrollView.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        case .create:
            toTomorrowView.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
            
            [confirmButton, bottomFadeView].forEach { view.addSubview($0) }
            confirmButton.snp.makeConstraints { make in
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
                make.height.equalTo(48)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            
            bottomFadeView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(confirmButton.snp.top)
                make.height.equalTo(24)
            }
            
            scrollView.snp.makeConstraints { make in
                make.bottom.equalTo(confirmButton.snp.top)
            }
        case .none:
            break
        }
    }
    
    private func setUpStyle() {
        view.backgroundColor = .white
    }
    
    private func setUpAction() {
        confirmButton.tapPublisher
            .sink { [weak self] in
                self?.recordCreationViewModel?.createDailyRecord()
                self?.view.window?.rootViewController?.dismiss(animated: true)
                
            }.store(in: &cancellables)
    }
    
    private func bind() {
        switch recordBrowseMode {
        case .read:
            bindWithDailyRecordViewModel()
        case.create:
            bindWithRecordCreationViewModel()
        case .none:
            break
        }
    }
    
    private func bindWithDailyRecordViewModel() {
        dailyRecordViewModel?.$currentDailyRecord
            .sink { [weak self] record in
                guard let record = record else { return }
                self?.setUpComponent(record: record)
            }.store(in: &cancellables)
        
        dailyRecordViewModel?.$currentPhraseFromYesterday
            .sink { [weak self] phrase in
                self?.fromYesterdayView.setUpComponent(text: phrase)
            }.store(in: &cancellables)
    }
    
    private func bindWithRecordCreationViewModel() {
        recordCreationViewModel?.$dailyRecord
            .sink { [weak self] record in
                self?.setUpComponent(record: record)
            }.store(in: &cancellables)
        
        recordCreationViewModel?.$phraseFromYesterday
            .sink { [weak self] phrase in
                self?.fromYesterdayView.setUpComponent(text: phrase)
            }.store(in: &cancellables)
    }
    
    private func setUpComponent(record: AttDailyRecord) {
        guard let moodColor = record.mood?.moodColor else { return }
        dateLabel.text = record.date.date()
        publicationTimeLabel.text = record.date.publicationDate()
        todaysMoodView.setUpColor(color: moodColor)
        nowPlayingView.configure(with: record.musicInfo)
        ticketDecorationView.setUpLineColor(color: moodColor)
        diaryView.setUpComponent(color: moodColor, content: record.diary)
        toTomorrowView.setUpComponent(text: record.phraseToTomorrow)
        
        // READ 모드에서만 미리듣기 자동재생
        guard recordBrowseMode == .read else { return }
        if let url = record.musicInfo?.previewURL {
            if url != currentPreviewURL {
                currentPreviewURL = url
                previewPlayer.play(url: url)
            }
        } else {
            currentPreviewURL = nil
            previewPlayer.stop()
        }
    }
}
