import UIKit
import SnapKit

class SearchResultTableViewCell: UITableViewCell {
    private let appearanceMode = UserInfoService.shared.getAppearance()
    private let dateLabel = TodoLabel(text: "", textColor: .lightGray)
    private let feelingImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        
        return image
    }()
    private let contentLabel = TodoLabel(text: "", textColor: .label)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        
        return collectionView
    }()
    
    private var hasImage: Bool = false
    private var hasCollectionData: Bool = false
    
    private var contentLabelTopConstraint: Constraint?
    private var collectionViewTopConstraint: Constraint?
    private var collectionViewHeightConstraint: Constraint?
    private var contentViewBottomConstraint: Constraint?
    private var todo: TodoModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialCell()
    }
    
    func initialCell() {
        contentView.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        contentView.addSubview(dateLabel)
        contentView.addSubview(feelingImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(collectionView)
        contentLabel.numberOfLines = 1
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentView.snp.top).offset(10)
        }
        
        feelingImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(50)
        }
        
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(15)
            $0.right.equalTo(contentView.snp.right).offset(-15)
            contentLabelTopConstraint = $0.top.equalTo(feelingImageView.snp.bottom).offset(5).constraint
        }
        
        collectionView.snp.makeConstraints {
            collectionViewTopConstraint = $0.top.equalTo(contentLabel.snp.bottom).offset(5).constraint
            $0.left.equalTo(contentView.snp.left).offset(10)
            $0.right.equalTo(contentView.snp.right).offset(-10)
            collectionViewHeightConstraint = $0.height.equalTo(0).constraint
            contentViewBottomConstraint = $0.bottom.equalTo(contentView.snp.bottom).offset(-10).constraint
        }
        
        feelingImageView.isHidden = true
        collectionView.isHidden = true
    }
    
    func configureCell(todo: TodoModel) {
        self.todo = todo
        dateLabel.text = todo.date
        hasImage = !todo.emotion.isEmpty
        feelingImageView.isHidden = !hasImage
        
        if hasImage {
            feelingImageView.image = UIImage(named: todo.emotion)
            contentLabelTopConstraint?.update(offset: 10)
        } else {
            feelingImageView.isHidden = true
            contentLabelTopConstraint?.update(offset: -40)
        }
        
        contentLabel.text = todo.content
        
        if let images = todo.images {
            hasCollectionData = images.count > 0
            collectionView.isHidden = !hasCollectionData
            
            if hasCollectionData {
                collectionViewHeightConstraint?.update(offset: 200)
                collectionView.isHidden = false
            } else {
                collectionViewHeightConstraint?.update(offset: 0)
                collectionView.isHidden = true
            }
        } else {
            hasCollectionData = false
            collectionViewHeightConstraint?.update(offset: 0)
            collectionView.isHidden = true
        }
        
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension SearchResultTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todo?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        
        if let todo = self.todo, let imageDatas = todo.images {
            let convertedImages = imageDatas.enumerated().compactMap { index, data -> UIImage? in
                let cacheKey = "\(todo.date)_\(index)"
                
                if let cachedImage = ImageCacheService.shared.getImage(key: cacheKey) {
                    return cachedImage
                }
                
                if let image = UIImage(data: data) {
                    ImageCacheService.shared.setImage(image: image, key: cacheKey)
                    return image
                }
                
                return nil
            }
            
            cell.configureCell(photo: convertedImages[indexPath.item], index: indexPath.item, deleteOption: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
