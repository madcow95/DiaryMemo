import UIKit
import SnapKit
import ReactorKit
import RxSwift

class FontSizeSlider: UIView {
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .primaryColor
        
        return button
    }()
    lazy var hLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        
        return line
    }()
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .primaryColor
        
        return button
    }()
    var circles: [UIButton] = []
    private var count: Int = 0
    private var prevCircle: UIButton?
    private weak var vc: SettingFontViewController?
    
    convenience init(
        count: Int,
        vc: SettingFontViewController?
    ) {
        self.init()
        self.count = count
        self.vc = vc
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSlider()
    }
    
    func initialSlider() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        self.addSubview(minusButton)
        self.addSubview(plusButton)
        self.addSubview(hLine)
        minusButton.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
        
        hLine.snp.makeConstraints {
            $0.left.equalTo(minusButton.snp.right).offset(10)
            $0.right.equalTo(plusButton.snp.left).offset(-10)
            $0.centerY.equalTo(self.snp.centerY)
            $0.height.equalTo(3)
        }
        
        plusButton.snp.makeConstraints {
            $0.right.equalTo(self.snp.right)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
    }
    
    func addButtonAction() {
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let currentFontSize = self.vc?.reactor?.currentState.currentFontSize, currentFontSize.rawValue > 0 {
                    self.vc?.reactor?.action.onNext(.changeFontSizeByButton(currentFontSize, .minus))
                }
            })
            .disposed(by: self.vc!.disposeBag)
        
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let currentFontSize = self.vc?.reactor?.currentState.currentFontSize, currentFontSize.rawValue < self.count - 1 {
                    self.vc?.reactor?.action.onNext(.changeFontSizeByButton(currentFontSize, .plus))
                }
            })
            .disposed(by: self.vc!.disposeBag)
    }
    
    func drawCircle(lineWidth: CGFloat, index: Int) {
        let xPoint: CGFloat = lineWidth / CGFloat(count - 1)
        for i in 0..<self.count {
            let circle = UIButton()
            var height: CGFloat = 10
            var tintColor: UIColor = .systemGray4
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            circle.backgroundColor = .clear
            
            if i == index {
                height = 20
                tintColor = .primaryColor
            }
            
            circle.tintColor = tintColor
            self.addSubview(circle)
            
            circle.snp.makeConstraints {
                if i == 0 {
                    $0.centerX.equalTo(hLine.snp.left)
                } else if i == self.count - 1 {
                    $0.centerX.equalTo(hLine.snp.right)
                } else {
                    $0.centerX.equalTo(hLine.snp.left).offset(xPoint * CGFloat(i))
                }
                $0.centerY.equalTo(hLine)
                $0.height.equalTo(height)
                $0.width.equalTo(height)
            }
            
            circle.rx.tap
                .subscribe { [weak self] _ in
                    self?.vc?.reactor?.action.onNext(.changeFontSize(FontCase.allCases[i]))
                }
                .disposed(by: self.vc!.disposeBag)
            
            circles.append(circle)
        }
    }
    
    func updateCircle(index: Int) {
        for i in 0..<self.count {
            var height: CGFloat = 10
            var tintColor: UIColor = .systemGray4
            
            if i == index {
                height = 20
                tintColor = .primaryColor
            }
            
            circles[i].tintColor = tintColor
            circles[i].snp.updateConstraints {
                $0.height.equalTo(height)
                $0.width.equalTo(height)
            }
        }
    }
}
