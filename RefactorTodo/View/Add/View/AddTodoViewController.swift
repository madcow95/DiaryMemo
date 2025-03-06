import UIKit
import PhotosUI
import SnapKit
import ReactorKit
import RxRelay

class AddTodoViewController: TodoViewController {
    var disposeBag = DisposeBag()
    let appearanceMode = UserInfoService.shared.getAppearance()
    
    private let emotionButton = AddButton(width: 25, height: 25, imageColor: .primaryColor, backgroundColor: .clear)
    private lazy var dateLabel = TodoLabel(text: reactor?.currentState.selectedDate.dateToString(),
                                           textColor: .lightGray,
                                           fontWeight: .bold)
    private lazy var photoCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: "PhotoCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        
        return collectionView
    }()
    private let placeholderText = "오늘의 일기를 작성해주세요"
    private lazy var todoContent: UITextView = {
        let textView = UITextView()
        let fontName = UserInfoService.shared.getFontName()
        let fontSize = UserInfoService.shared.getFontSize()
        if fontName == "normal" {
            textView.font = UIFont.systemFont(ofSize: fontSize.fontSize)
        } else {
            textView.font = UIFont(name: fontName, size: fontSize.fontSize)
        }
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        textView.text = "오늘의 일기를 작성해주세요"
        textView.textColor = textView.text == "오늘의 일기를 작성해주세요" ? .lightGray : .black
        textView.delegate = self
        
        return textView
    }()
    private let photoButton = CustomButton(width: 50,
                                           height: 50,
                                           image: UIImage(systemName: "photo.fill"),
                                           tintColor: .primaryColor)
    private let hideKeyboardButton = CustomButton(width: 50,
                                                  height: 50,
                                                  image: UIImage(systemName: "keyboard.chevron.compact.down.fill"),
                                                  tintColor: .primaryColor)
    private let saveButton = CustomButton(width: 50,
                                          height: 50,
                                          image: UIImage(systemName: "checkmark"),
                                          tintColor: .primaryColor)
    private var isKeyboardVisible = BehaviorRelay<Bool>(value: false)
    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        let leftSpacer = UIView()
        
        stack.addArrangedSubview(photoButton)
        stack.addArrangedSubview(leftSpacer)
        stack.addArrangedSubview(hideKeyboardButton)
        stack.addArrangedSubview(saveButton)
        
        leftSpacer.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(0)
        }
        
        stack.setCustomSpacing(10, after: hideKeyboardButton)
        
        return stack
    }()
    private var photoCollectionHeightConstraint: Constraint?
    private lazy var deleteButton = UIBarButtonItem(
        image: UIImage(systemName: "trash.fill")?.withTintColor(.primaryColor, renderingMode: .alwaysOriginal),
        style: .done,
        target: self,
        action: nil
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.loadTodo(reactor?.initialState.selectedDate ?? Date()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardButton.alpha = 0.0
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        photoCollection.delegate = nil
        photoCollection.dataSource = nil
        reactor?.action.onNext(.clearPhotos)
        photoCollection.removeFromSuperview()
    }
    
    func configureUI() {
        configureButton()
        configureLabel()
        configureBottomView()
        configureCollectionView()
        configureTextView()
    }
    
    func configureButton() {
        view.addSubview(emotionButton)
        emotionButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func configureLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(emotionButton.snp.bottom).offset(5)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func configureBottomView() {
        view.addSubview(bottomStackView)
        
        bottomStackView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(50)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { _ in }
    }
    
    func configureCollectionView() {
        view.addSubview(photoCollection)
        photoCollection.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
            photoCollectionHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    func configureTextView() {
        view.addSubview(todoContent)
        todoContent.snp.makeConstraints {
            $0.top.equalTo(photoCollection.snp.bottom).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-10)
        }
    }
}

extension AddTodoViewController: View {
    func bind(reactor: AddTodoReactor) {
        // MARK: TODO - 이모티콘으로 제한하지 말고 사용자가 원하는 사진으로도 선택할 수 있게 해보기
        emotionButton.rx.tap
            .map { .showEmotionView(reactor.currentState.selectedDate) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        photoButton.rx.tap
            .map { .showPhotoLibrary }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        isKeyboardVisible
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isVisible in
                UIView.animate(withDuration: 0.3) {
                    self?.hideKeyboardButton.alpha = isVisible ? 1.0 : 0.0
                }
            })
            .disposed(by: disposeBag)
        
        Observable.merge([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        ])
        .bind(to: isKeyboardVisible)
        .disposed(by: disposeBag)
        
        hideKeyboardButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map { [weak self] _ in
                let date = self?.reactor?.currentState.selectedDate.dateToString(includeDay: .day) ?? "Unknown Date"
                let content = self?.todoContent.text ?? ""
                var emotion = ""
                if let selectedIdx = self?.reactor?.currentState.selectedImageIndex {
                    emotion = "emoji_\(selectedIdx).png"
                }
                let todo = TodoModel(
                    date: date,
                    content: content,
                    emotion: emotion,
                    images: []
                )
                
                return .addTodo(todo, self?.reactor?.currentState.selectedPhotos ?? [])
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return Observable.create { observer in
                    let alert = UIAlertController(
                        title: "삭제",
                        message: "정말 삭제하시겠습니까?",
                        preferredStyle: .alert
                    )
                    
                    let okAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                    
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                    
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true)
                    
                    return Disposables.create {
                        alert.dismiss(animated: true)
                    }
                }
            }
            .filter { $0 }
            .map { _ in
                if let todo = reactor.currentState.existTodo {
                    return .deleteTodo(todo)
                }
                return .none
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.existTodo }
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] todo in
                self?.todoContent.text = todo.content
                self?.todoContent.textColor = .black
                if todo.emotion.isEmpty {
                    self?.emotionButton.setImage(UIImage(systemName: "plus"), for: .normal)
                } else {                
                    self?.emotionButton.setImage(UIImage(named: todo.emotion), for: .normal)
                }
                self?.navigationItem.rightBarButtonItem = self?.deleteButton
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedImageIndex }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { $0 }
            .map { UIImage(named: "emoji_\($0).png") }
            .bind(to: emotionButton.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedPhotos }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] photos in
                if let elements = photos.element, !elements.isEmpty {
                    self?.photoCollectionHeightConstraint?.update(offset: 170)
                } else {
                    self?.photoCollectionHeightConstraint?.update(offset: 0)
                }
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
                self?.photoCollection.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension AddTodoViewController: PHPickerViewControllerDelegate {
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
                self?.reactor?.action.onNext(.imageSelected(validImages))
            }, onFailure: { error in
                print("Failed to load images: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.selectedPhotos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        
        if let image = reactor?.currentState.selectedPhotos[indexPath.item] {
            cell.configureCell(photo: image, index: indexPath.item)
            cell.photoDelegate = self
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let loadedImage = reactor?.currentState.selectedPhotos {
            reactor?.action.onNext(.showImageViewer(loadedImage, indexPath.item))
        }
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

extension AddTodoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    // 텍스트뷰 편집 종료할 때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}

extension AddTodoViewController: PhotoDeleteDelegate {
    func deletePhoto(index: Int) {
        reactor?.action.onNext(.deleteImage(index))
    }
}
