import UIKit
import SnapKit
import ReactorKit

class EmotionViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private lazy var selectedDate = reactor?.selectedDate
    private lazy var dateLabel = TodoLabel(text: Date().dateToString(date: selectedDate),
                                           textColor: .lightGray,
                                           fontWeight: .bold)
    private let todayEmotionLabel = TodoLabel(text: "오늘은 어떤 하루였나요?",
                                              fontSize: 17,
                                              fontWeight: .semibold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureLabel()
    }
    
    func configureLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(todayEmotionLabel)
        todayEmotionLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}

extension EmotionViewController: View {
    func bind(reactor: EmotionReactor) {
        
    }
}
