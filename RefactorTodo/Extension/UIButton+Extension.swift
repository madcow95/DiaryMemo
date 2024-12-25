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
    
    func initialButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 25
        self.backgroundColor = .systemGreen
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = .white
    }
}
