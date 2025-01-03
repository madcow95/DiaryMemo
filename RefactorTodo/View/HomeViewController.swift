import UIKit
import SnapKit
import FSCalendar
import ReactorKit
import RxSwift

class HomeViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    private let calendarView = TodoCalendar()
    private let addButton = AddButton(width: 50, height: 50)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currentPage = calendarView.currentPage
        reactor?.action.onNext(.loadAllTodosByYearMonth(currentPage))
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
        configureAddButton()
    }
    
    func configureCalendar() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-150)
        }
    }
    
    func configureAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.right.equalTo(view.snp.right).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        reactor?.action.onNext(.moveToAddView(date))
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        reactor?.action.onNext(.loadAllTodosByYearMonth(currentPage))
        calendarView.reloadData()
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
        }
    }
}

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        addButton.rx.tap
            .map { Reactor.Action.moveToAddView(Date()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.existTodos }
            .bind(onNext: { [weak self] todos in
                self?.calendarView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
