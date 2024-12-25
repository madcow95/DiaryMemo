import UIKit
import RxCocoa

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
        width: CGFloat = 50,
        height: CGFloat = 50
    ) {
        self.init()
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.layer.cornerRadius = width / 2
    }
    
    func initialButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGreen
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = .white
    }
}
