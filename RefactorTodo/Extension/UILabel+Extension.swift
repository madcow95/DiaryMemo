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
        fontSize: CGFloat = 14,
        fontWeight: UIFont.Weight = .regular
    ) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    func initialLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
