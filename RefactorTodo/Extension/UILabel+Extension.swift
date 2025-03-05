import UIKit

// 공통으로 쓰기 위한 UILabel
class TodoLabel: UILabel {
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
        fontWeight: UIFont.Weight = .regular
    ) {
        self.init()
        self.text = text
        self.textColor = textColor
        updateFontSize(fontSize: fontSize)
    }
    
    /// 현재 UserDefault에 저장된 폰트, 폰트크기로 설정
    func updateFontSize(fontSize: CGFloat? = nil, fontName: String? = nil, byPass: Bool = false) {
        let savedFontSize = UserInfoService.shared.getFontSize().fontSize
        let savedFontName = UserInfoService.shared.getFontName()
        if savedFontName == "normal" {
            self.font = UIFont.systemFont(ofSize: fontSize ?? savedFontSize)
        } else {
            self.font = UIFont(name: fontName ?? savedFontName, size: fontSize ?? savedFontSize)
        }
        
        if byPass {
            self.font = UIFont(name: fontName ?? savedFontName, size: 16)
        }
    }
    
    func initialLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
