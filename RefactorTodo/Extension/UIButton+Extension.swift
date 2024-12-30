import UIKit
import RxCocoa

// 공통으로 쓰기 위한 UIButton
class AddButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialButton()
    }
    
    convenience init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        image: UIImage? = nil,
        title: String = ""
    ) {
        self.init()
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
            self.layer.cornerRadius = width / 2
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
            self.layer.cornerRadius = height / 2
        }
        if let img = image {
            self.setImage(img, for: .normal)
        }
        if !title.isEmpty {
            self.setTitle(title, for: .normal)
        }
    }
    
    func initialButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGreen
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = .white
    }
}
