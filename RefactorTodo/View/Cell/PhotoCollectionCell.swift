import UIKit
import SnapKit

class PhotoCollectionCell: UICollectionViewCell {
    
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    func configureCell(photo: UIImage) {
        self.photoView.image = photo
    }
}
