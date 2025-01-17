import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    private let titleLabel = TodoLabel(text: "", textColor: .black)
    private let chevoronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        
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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(15)
        }
        
        contentView.addSubview(chevoronImageView)
        chevoronImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-15)
            $0.width.height.equalTo(20)
        }
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
        titleLabel.updateFontSize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        chevoronImageView.image = nil
        titleLabel.text = nil
    }
}
