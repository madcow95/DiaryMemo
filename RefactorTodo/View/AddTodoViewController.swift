import UIKit
import PhotosUI
import SnapKit
import ReactorKit

class AddTodoViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private let emotionButton = AddButton(width: 25, height: 25)
    private lazy var dateLabel = TodoLabel(text: reactor?.currentState.selectedDate.dateToString(),
                                           textColor: .lightGray,
                                           fontWeight: .bold)
    private let placeholderText = "오늘의 일기를 작성해주세요"
    private lazy var todoContent: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.backgroundColor = .white
        textView.text = "오늘의 일기를 작성해주세요"
        textView.textColor = textView.text == "오늘의 일기를 작성해주세요" ? .lightGray : .black
        textView.delegate = self
        
        return textView
    }()
    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.addArrangedSubview(photoButton)
        stack.addArrangedSubview(saveButton)
        stack.distribution = .equalSpacing
        
        return stack
    }()
    private let photoButton = CustomButton(width: 50,
                                           height: 50,
                                           image: UIImage(systemName: "photo.fill"),
                                           tintColor: .systemGreen)
    private let saveButton = CustomButton(width: 50,
                                          height: 50,
                                          image: UIImage(systemName: "checkmark"),
                                          tintColor: .systemGreen)
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
        
        return collectionView
    }()
    private var photoCollectionHeightConstraint: Constraint?
    private lazy var deleteButton = UIBarButtonItem(
        image: UIImage(systemName: "trash.fill")?.withTintColor(.systemGreen),
        style: .done,
        target: self,
        action: nil
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.loadTodo(reactor?.initialState.selectedDate ?? Date()))
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        emotionButton.rx.tap
            .map { Reactor.Action.showEmotionView(reactor.currentState.selectedDate) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        photoButton.rx.tap
            .map { Reactor.Action.showPhotoLibrary }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map { [weak self] _ in
                let todo = TodoModel(
                    id: UUID().uuidString,
                    date: self?.reactor?.currentState.selectedDate.dateToString(includeDay: .day) ?? "Unknown Date",
                    content: self?.todoContent.text ?? "",
                    emotion: "emoji_\(self?.reactor?.currentState.selectedImageIndex ?? 0).png",
                    photoPath: []
                )
                
                return Reactor.Action.addTodo(todo, self?.reactor?.currentState.selectedPhotos ?? [])
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map { _ in
                if let todo = reactor.currentState.existTodo {
                    return Reactor.Action.deleteTodo(todo)
                }
                return Reactor.Action.none
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.existTodo }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] todo in
                self?.todoContent.text = todo.content
                self?.todoContent.textColor = .black
                self?.emotionButton.setImage(UIImage(named: todo.emotion), for: .normal)
                self?.navigationItem.rightBarButtonItem = self?.deleteButton
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedImageIndex }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { $0 }
            .map { "emoji_\($0).png" }
            .map { UIImage(named: $0) }
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
