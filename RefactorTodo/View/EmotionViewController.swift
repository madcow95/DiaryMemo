import UIKit
import SnapKit
import ReactorKit

class EmotionViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private lazy var dateLabel = TodoLabel(text: reactor?.currentState.selectedDate.dateToString(),
                                           textColor: .lightGray,
                                           fontWeight: .bold)
    private let todayEmotionLabel = TodoLabel(text: "오늘은 어떤 하루였나요?",
                                              fontSize: 17,
                                              fontWeight: .semibold)
    private lazy var emotionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: "EmotionCollectionViewCell")
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureLabel()
        configureTable()
    }
    
    func configureLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(todayEmotionLabel)
        todayEmotionLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func configureTable() {
        view.addSubview(emotionCollectionView)
        emotionCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayEmotionLabel.snp.bottom).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension EmotionViewController: View {
    func bind(reactor: EmotionReactor) {
        emotionCollectionView.rx.itemSelected
            .map { Reactor.Action.emotionSelect($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.emotionSelected }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension EmotionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.emotionImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCollectionViewCell", for: indexPath) as? EmotionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let imgName = reactor?.currentState.emotionImages[indexPath.item] {
            cell.configureCell(imgName: imgName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let width = (collectionView.frame.width - spacing * 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing: CGFloat) -> CGFloat {
        return 10
    }
}
