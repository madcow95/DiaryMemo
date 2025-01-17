import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    private let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .primaryColor
        
        return imageView
    }()
    private let titleLabel = TodoLabel(text: "", textColor: .black)
    
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
    }
    
    func configureCell(title: String, imageName: String) {
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
