import UIKit
import SnapKit

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
    private var count: Int = 0
    private var index: Int = 3
    private var prevCircle: UIButton?
    
    convenience init(
        count: Int,
        index: Int
    ) {
        self.init()
        self.count = count
        self.index = index
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
    
    func drawCircle(lineWidth: CGFloat) {
        let xPoint: CGFloat = lineWidth / CGFloat(count - 1)
        for i in 0..<self.count {
            let circle = UIButton()
            var height: CGFloat = 10
            var tintColor: UIColor = .systemGray4
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            
            if i == index {
                height = 20
                tintColor = .primaryColor
            }
            
            circle.tintColor = tintColor
            self.addSubview(circle)
            
            circle.snp.makeConstraints {
                if i == 0 {
                    // 첫 번째 원의 centerX를 hLine의 left와 일치
                    $0.centerX.equalTo(hLine.snp.left)
                } else if i == self.count - 1 {
                    // 마지막 원의 centerX를 hLine의 right와 일치
                    $0.centerX.equalTo(hLine.snp.right)
                } else {
                    $0.left.equalTo(hLine.snp.left).offset(xPoint * CGFloat(i))
                }
                $0.centerY.equalTo(hLine)
                $0.height.equalTo(height)
                $0.width.equalTo(height)
            }
        }
    }
}
