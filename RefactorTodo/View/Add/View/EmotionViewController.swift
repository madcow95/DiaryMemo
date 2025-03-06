import UIKit
import SnapKit
import ReactorKit
import PhotosUI

class EmotionViewController: TodoViewController {
    var disposeBag = DisposeBag()
    let appearanceMode = UserInfoService.shared.getAppearance()
    private lazy var dateLabel = TodoLabel(text: reactor?.currentState.selectedDate.dateToString(),
                                           textColor: .lightGray,
                                           fontWeight: .bold)
    private lazy var todayEmotionLabel = TodoLabel(text: "오늘은 어떤 하루였나요?",
                                                   textColor: appearanceMode == "Dark" ? .white : .black, fontSize: 17,
                                                   fontWeight: .semibold)
    private lazy var emotionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: "EmotionCollectionViewCell")
        
        return collection
    }()
    private lazy var imageButton = CustomButton(width: view.frame.width - 100,
                                                height: 50,
                                                image: UIImage(systemName: "photo"),
                                                tintColor: .primaryColor,
                                                backgroundColor: .primaryColor.withAlphaComponent(0.5),
                                                cornerRadius: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        configureLabel()
        configureTable()
        configureButton()
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
        }
    }
    
    func configureButton() {
        view.addSubview(imageButton)
        imageButton.snp.makeConstraints {
            $0.top.equalTo(emotionCollectionView.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension EmotionViewController: View {
    func bind(reactor: EmotionReactor) {
        emotionCollectionView.rx.itemSelected
            .map { .emotionSelect($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageButton.rx.tap
            .map { .presentGallery }
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

extension EmotionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
            
        guard !results.isEmpty else { return }
        
        let imageRequests = results.map { result -> Single<UIImage?> in
            return Single<UIImage?>.create { single in
                let provider = result.itemProvider
                
                guard provider.canLoadObject(ofClass: UIImage.self) else {
                    single(.success(nil))
                    return Disposables.create()
                }
                
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    single(.success(image as? UIImage))
                }
                
                return Disposables.create()
            }
        }
        
        Single.zip(imageRequests)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] images in
                let validImages = images.compactMap { $0 }
                self?.reactor?.action.onNext(.imageSelected(validImages.first!))
            }, onFailure: { error in
                print("Failed to load images: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
