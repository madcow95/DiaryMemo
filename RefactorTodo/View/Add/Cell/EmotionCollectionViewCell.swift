import UIKit
import SnapKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
    // 감정 이모티콘을 표현할 ImageView
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
    
    // 화면에 감정 이모티콘 UIImageView의 Constraint 설정
    func initialCell() {
        contentView.addSubview(emotionImage)
        emotionImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // 감정 이모티콘에 실제 이미지를 표시
    func configureCell(imgName: String) {
        emotionImage.image = UIImage(named: imgName)
    }
}
