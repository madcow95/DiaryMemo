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
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .systemGray4
        slider.maximumTrackTintColor = .systemGray4
        
        let thumbSize: CGFloat = 15
        let configuration = UIImage.SymbolConfiguration(pointSize: thumbSize)
        let thumbImage = UIImage(systemName: "circle.fill")?
            .withConfiguration(configuration)
            .withTintColor(.clear, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        slider.minimumValue = 0
        slider.maximumValue = 6
        slider.value = 3
        
        return slider
    }()
    private var tickButtons: [UIButton] = []
    
    private lazy var ticksContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
        view.addSubview(ticksContainerView)
        
        slider.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.centerY.equalToSuperview()
        }
        
        ticksContainerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(slider)
            $0.height.equalTo(10)
            $0.centerY.equalTo(slider)
        }
        
        setupTicks()
    }
    
    func setupTicks() {
        let tickCount = 7
        
        let totalWidth = view.frame.width - 80
        let spacing = totalWidth / CGFloat(tickCount - 1)
        
        for i in 0..<tickCount {
            var tickHeight: CGFloat = 10
            let tickButton = UIButton()
            tickButton.backgroundColor = .systemGray4
            ticksContainerView.addSubview(tickButton)
            
            if i == reactor?.currentState.currentFontSize.rawValue {
                tickHeight = 20
                tickButton.backgroundColor = .primaryColor
            }
            tickButton.layer.cornerRadius = tickHeight / 2
            
            let xPosition = CGFloat(i) * spacing
            tickButton.snp.makeConstraints {
                $0.width.equalTo(tickHeight)
                $0.height.equalTo(tickHeight)
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(xPosition)
            }
            tickButton.rx.tap
                .map { Reactor.Action.changeFontSize(FontCase.allCases[i]) }
                .bind(to: reactor!.action)
                .disposed(by: disposeBag)
            
            tickButtons.append(tickButton)
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
    }
}

extension SettingFontViewController: View {
    func bind(reactor: SettingFontReactor) {
        reactor.state.map { $0.currentFontSize.rawValue }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] idx in
                guard let self = self else { return }
                if self.tickButtons.count > 0 {
                    for i in 0..<7 {
                        var tickHeight: CGFloat = 10
                        let tickButton = self.tickButtons[i]
                        tickButton.backgroundColor = .systemGray4
                        
                        if i == idx.element! {
                            tickHeight = 20
                            tickButton.backgroundColor = .primaryColor
                        }
                        tickButton.layer.cornerRadius = tickHeight / 2
                        
                        tickButton.snp.updateConstraints {
                            $0.width.equalTo(tickHeight)
                            $0.height.equalTo(tickHeight)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
