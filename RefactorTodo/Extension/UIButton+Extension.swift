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
        image: UIImage? = UIImage(systemName: "plus"),
        title: String = "",
        imageColor: UIColor = .white,
        backgroundColor: UIColor = .systemGreen
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
            self.tintColor = imageColor
        }
        if !title.isEmpty {
            self.setTitle(title, for: .normal)
        }
        self.backgroundColor = backgroundColor
    }
    
    func initialButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = .white
    }
}

/// width, height, image 등을 한 번에 설정할 수 있는 CustomButton
class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        image: UIImage? = nil,
        title: String? = nil,
        tintColor: UIColor? = nil,
        backgroundColor: UIColor? = .clear,
        cornerRadius: CGFloat? = nil
    ) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let image = image {
            self.setImage(image, for: .normal)
        }
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
