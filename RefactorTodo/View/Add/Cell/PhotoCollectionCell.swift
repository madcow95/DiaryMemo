import UIKit
import SnapKit

final class PhotoCollectionCell: UICollectionViewCell {
    var photoDelegate: PhotoDeleteDelegate?
    private var photoIndex: Int = -1
    // 일기를 작성할 때 저장했던 ImageView
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialCell()
    }
    
    private func initialCell() {
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    func configureCell(photo: UIImage, index: Int, deleteOption: Bool = true) {
        self.photoView.image = photo
        self.photoIndex = index
        
        if deleteOption {        
            let interaction = UIContextMenuInteraction(delegate: self)
            self.addInteraction(interaction)
        }
    }
    
    // Cell의 재사용 방지
    override func prepareForReuse() {
       super.prepareForReuse()
       
       photoView.image = nil
   }
}

extension PhotoCollectionCell: UIContextMenuInteractionDelegate {
    // 이미지를 길게 눌렀을 때 삭제 가능한 context menu 출력
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ -> UIMenu? in
                
                let delete = UIAction(
                    title: "삭제",
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive) { [weak self] _ in
                    // 삭제 액션 처리
                        if let index = self?.photoIndex, index > -1 {
                            self?.photoDelegate?.deletePhoto(index: index)
                        }
                }
                
                return UIMenu(children: [delete])
        }
    }
}
