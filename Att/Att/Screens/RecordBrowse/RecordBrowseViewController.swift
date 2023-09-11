//
//  RecordBrowseViewController.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

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
    
    // MARK: Init 선언부
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle 선언부
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Do any additional setup after loading the view.
    }

    // MARK: viewDidLoad 시 1회성 호출을 필요로하는 method 일괄
    private func configure() {
        setUpConstriants()
        setUpStyle()
        setUpAction()
        bind()
    }
    
    // MARK: Components 간의 위치 설정
    // MARK: Constraints 설정 순서는 top - bottom - leading - trailing - centerX - centerY - width - height 순으로
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
    
    // MARK: ViewModel Stuff - Optional
    private func bind() {
        dateLabel.text = Date().date()
        publicationTimeLabel.text = "발행시간 2023. 9. 11. KST 23:50"
        todaysMoodView.setUpColor(color: .cherry)
        nowPlayingView.setUpComponent(title: "누군가 - 부르는 노래", image: UIImage())
        fromYesterdayView.setUpComponent(text: "열심히 무언가를 하다")
        ticketDecorationView.setUpLineColor(color: .cherry)
        diaryView.setUpComponent(color: .cherry, content: "")
        toTomorrowView.setUpComponent(text: "피곤의 악마와 계약을 하다...")
    }
}
