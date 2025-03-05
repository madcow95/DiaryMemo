import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    enum CellCase {
        case chevron
        case toggle
    }
    
    private let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .primaryColor
        
        return imageView
    }()
    private let darkThemeToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .primaryColor
        
        return toggle
    }()
    private let titleLabel = TodoLabel(text: "", textColor: .black)
    private let chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .primaryColor
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialCell()
    }
    
    func initialCell() {
        contentView.backgroundColor = .todoBackgroundColor
        
        contentView.addSubview(titleImage)
        titleImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(15)
            $0.width.height.equalTo(15)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(titleImage.snp.right).offset(5)
        }
        
        contentView.addSubview(darkThemeToggle)
        darkThemeToggle.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-15)
        }
        
        contentView.addSubview(chevronImage)
        chevronImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-15)
        }
    }
    
    func configureCell(title: String, imageName: String, cellType: CellCase) {
        if cellType == .chevron {
            darkThemeToggle.isHidden = true
            chevronImage.isHidden = false
        } else {
            darkThemeToggle.isHidden = false
            chevronImage.isHidden = true
        }
        titleLabel.text = title
        titleLabel.updateFontSize()
        titleImage.snp.updateConstraints {
            $0.width.height.equalTo(titleLabel.font.pointSize)
        }
        titleImage.image = UIImage(systemName: imageName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleImage.image = nil
        titleLabel.text = nil
    }
}
