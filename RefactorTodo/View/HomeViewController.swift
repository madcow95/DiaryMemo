import UIKit
import SnapKit
import FSCalendar
import ReactorKit
import RxSwift

class HomeViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    private let calendarView = TodoCalendar()
    private let addButton = AddButton(width: 50, height: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        configureCalendar()
        configureAddButton()
    }
    
    func configureCalendar() {
        self.calendarView.delegate = self
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

extension HomeViewController: FSCalendarDelegate {
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        reactor?.action.onNext(.moveToAddView(date))
    }
}

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        addButton.rx.tap
            .map { Reactor.Action.moveToAddView(Date()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
    }
}
