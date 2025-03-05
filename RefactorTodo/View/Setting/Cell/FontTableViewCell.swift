import UIKit
import SnapKit

class FontTableViewCell: UITableViewCell {
    private let appearanceMode = UserInfoService.shared.getAppearance()
    private lazy var titleLabel = TodoLabel(text: "", textColor: .label)
    let checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .primaryColor
        imageView.isHidden = true
        
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
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(10)
        }
        
        contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-10)
            $0.width.height.equalTo(25)
        }
        
        contentView.backgroundColor = appearanceMode == "Dark" ? .lightGray : .white
    }
    
    func configureCell(title: String, fontName: String, fontSelected: Bool) {
        titleLabel.text = title
        checkImageView.isHidden = !fontSelected
        titleLabel.updateFontSize(fontSize: FontCase.normal.fontSize,
                                  fontName: fontName,
                                  byPass: true)
    }
}
