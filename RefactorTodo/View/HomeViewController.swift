import UIKit
import SnapKit
import FSCalendar
import ReactorKit
import RxSwift

class HomeViewController: TodoViewController {
    
    var disposeBag = DisposeBag()
    private lazy var calendarView = TodoCalendar()
    private let addButton = AddButton(width: 50, height: 50, backgroundColor: .primaryColor)
    private lazy var settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"),
                                                     style: .done,
                                                     target: self,
                                                     action: nil)
    
    // view가 시작될 때 달력 초기화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.layoutIfNeeded()
        reactor?.action.onNext(.loadAllTodosByYearMonth(calendarView.currentPage))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CoreDataService.shared.deleteAllData()
//            .subscribe(onNext: {
//                print("삭제완료")
//            })
//            .disposed(by: disposeBag)
        configureUI()
    }
    
    func configureUI() {
        configureCalendar()
        configureButton()
    }
    
    func configureCalendar() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            $0.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height - 200)
        }
    }
    
    func configureButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.right.equalTo(view.snp.right).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        settingButton.tintColor = .primaryColor
        self.navigationItem.rightBarButtonItem = settingButton
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
        reactor?.action.onNext(.moveToAddView(date))
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        reactor?.action.onNext(.loadAllTodosByYearMonth(currentPage))
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateStr = date.dateToString(includeDay: .day)
        if let todo = reactor?.currentState.existTodos.first(where: { $0.date == dateStr }) {
            let imageView = UIImageView(image: UIImage(named: todo.emotion))
            imageView.contentMode = .scaleAspectFit
            cell.backgroundView = imageView
            cell.titleLabel.isHidden = true
            cell.appearance.todayColor = .clear
        } else {
            cell.backgroundView = nil
            cell.titleLabel.isHidden = false
            cell.appearance.todayColor = .clear
            
            if date.dateToString() == Date().dateToString() {
                cell.backgroundView = nil
                cell.appearance.titleTodayColor = .primaryColor
                cell.titleLabel.isHidden = false
            }
        }
    }
}

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        addButton.rx.tap
            .map { Reactor.Action.moveToAddView(Date()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .map { Reactor.Action.moveToSetting }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.existTodos }
            .bind(onNext: { [weak self] todos in
                self?.calendarView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
