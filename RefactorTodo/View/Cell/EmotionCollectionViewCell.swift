import UIKit
import SnapKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
    lazy var emotionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialCell()
    }
    
    func initialCell() {
        contentView.addSubview(emotionImage)
        emotionImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(imgName: String) {
        emotionImage.image = UIImage(named: imgName)
    }
}
