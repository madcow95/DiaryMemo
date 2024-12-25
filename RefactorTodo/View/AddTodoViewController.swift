import UIKit
import SnapKit
import ReactorKit

class AddTodoViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private lazy var selectedDate = reactor?.addTodoCoordinator?.selectedDate
    private let emotionButton = AddButton(width: 25, height: 25)
    private lazy var dateLabel = TodoLabel(text: Date().dateToString(date: selectedDate),
                                      textColor: .lightGray,
                                      fontWeight: .bold)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: TODO - 선택된 날짜에 등록된 일기가 없을 때 실행
        reactor?.action.onNext(.showEmotionView(selectedDate ?? Date()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        navigationController?.tabBarController?.isTabBarHidden = true
        configureButton()
        configureLabel()
    }
    
    func configureButton() {
        view.addSubview(emotionButton)
        emotionButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func configureLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(emotionButton.snp.bottom).offset(5)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}

extension AddTodoViewController: View {
    func bind(reactor: AddTodoReactor) {
        emotionButton.rx.tap
            .map { Reactor.Action.showEmotionView(self.selectedDate ?? Date()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
