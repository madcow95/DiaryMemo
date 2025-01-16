import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SettingFontViewController: TodoViewController {
    var disposeBag = DisposeBag()
    private lazy var previewContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 10
        container.backgroundColor = .white
        
        return container
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "emoji_\((0..<13).randomElement()!)")
        
        return imageView
    }()
    private let dateLabel = TodoLabel(text: Date().dateToString(includeDay: .dayOfWeek),
                                      textColor: .lightGray)
    private let firstPreviewLabel = TodoLabel(text: "일기를 쓰는 습관 :)")
    private let secondPreviewLabel = TodoLabel(text: "변경된 폰트 사이즈가 표시됩니다")
    private let slider = FontSizeSlider(count: 7, index: FontCase.normal.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        self.title = "글자 스타일"
        configurePreview()
        configureSlider()
    }
    
    func configurePreview() {
        view.addSubview(previewContainer)
        previewContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.height.equalTo(200)
        }
        
        previewContainer.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalTo(previewContainer.snp.top).offset(10)
            $0.centerX.equalTo(previewContainer.snp.centerX)
            $0.height.equalTo(50)
        }
        
        previewContainer.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.centerX.equalTo(previewContainer.snp.centerX)
        }
        
        previewContainer.addSubview(firstPreviewLabel)
        firstPreviewLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.left.equalTo(previewContainer.snp.left).offset(10)
            $0.right.equalTo(previewContainer.snp.right).offset(-10)
        }
        
        previewContainer.addSubview(secondPreviewLabel)
        secondPreviewLabel.snp.makeConstraints {
            $0.top.equalTo(firstPreviewLabel.snp.bottom)
            $0.left.equalTo(previewContainer.snp.left).offset(10)
            $0.right.equalTo(previewContainer.snp.right).offset(-10)
        }
    }
    
    func configureSlider() {
        view.addSubview(slider)
        slider.snp.makeConstraints {
            $0.top.equalTo(previewContainer.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
        }

        view.layoutIfNeeded()
        
        slider.drawCircle(lineWidth: slider.hLine.frame.width)
    }
}

extension SettingFontViewController: View {
    func bind(reactor: SettingFontReactor) {
//        reactor.state.map { $0.currentFontSize.rawValue }
//            .observe(on: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe { [weak self] idx in
//                guard let self = self else { return }
//                
//            }
//            .disposed(by: disposeBag)
    }
}
