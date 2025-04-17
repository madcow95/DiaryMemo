import UIKit
import SnapKit

final class EmotionCollectionViewCell: UICollectionViewCell {
    
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialCell()
    }
    
    // 화면에 감정 이모티콘 UIImageView의 Constraint 설정
    private func initialCell() {
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
