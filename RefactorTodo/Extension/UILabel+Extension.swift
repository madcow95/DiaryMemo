import UIKit

// 공통으로 쓰기 위한 UILabel
class TodoLabel: UILabel {
    lazy var savedFontSize = UserInfoService.shared.getFontSize().fontSize
    lazy var savedFontName = UserInfoService.shared.getFontName()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialLabel()
    }
    
    convenience init(
        text: String?,
        textColor: UIColor = .black,
        fontSize: CGFloat? = nil,
        fontWeight: UIFont.Weight = .regular,
        isDefaultSize: Bool = true
    ) {
        self.init()
        self.text = text
        self.textColor = textColor
        if let fontSize = fontSize {
            self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        } else {
            if isDefaultSize {
                let fontSize = UserInfoService.shared.getFontSize()
                self.font = UIFont.systemFont(ofSize: fontSize.fontSize, weight: fontWeight)
            }
        }
    }
    
    func updateFontSize() {
        self.font = UIFont.systemFont(ofSize: UserInfoService.shared.getFontSize().fontSize)
    }
    
    func initialLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
