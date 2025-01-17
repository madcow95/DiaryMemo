import UIKit
import SnapKit

class FontTableViewCell: UITableViewCell {
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
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(10)
        }
    }
    
    func configureCell(title: String, fontName: String) {
        titleLabel.text = title

        titleLabel.updateFontSize(fontSize: FontCase.normal.fontSize, fontName: fontName)
    }
}
