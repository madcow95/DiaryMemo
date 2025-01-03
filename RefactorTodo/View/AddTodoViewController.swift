import UIKit
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
    private let addButton = AddButton(height: 50, title: "추가하기")
    private lazy var deleteButton = UIBarButtonItem(
        image: UIImage(systemName: "trash.fill")?.withTintColor(.systemGreen),
        style: .done,
        target: self,
        action: nil
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        reactor?.action.onNext(.showEmotionView(reactor?.initialState.selectedDate ?? Date()))
        reactor?.action.onNext(.loadTodo(reactor?.initialState.selectedDate ?? Date()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        navigationController?.tabBarController?.isTabBarHidden = true
        configureButton()
        configureLabel()
        configureTextView()
        configureAddButton()
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
    
    func configureTextView() {
        view.addSubview(todoContent)
        todoContent.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
        }
    }
    
    func configureAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.equalTo(todoContent.snp.bottom).offset(10)
            $0.left.right.equalTo(todoContent)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
    }
}

extension AddTodoViewController: View {
    func bind(reactor: AddTodoReactor) {
        emotionButton.rx.tap
            .map { Reactor.Action.showEmotionView(reactor.currentState.selectedDate) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { [weak self] _ in
                let todo = Todo(context: CoreDataService.shared.context)
                todo.content = self?.todoContent.text ?? ""
                todo.date = self?.reactor?.currentState.selectedDate.dateToString(includeDay: .day) ?? "Unknown Date"
                todo.emotion = "emoji_\(self?.reactor?.currentState.selectedImageIndex ?? 0).png"
                todo.id = UUID().uuidString
                
                if let titleLabel = self?.addButton.titleLabel, let title = titleLabel.text {
                    if title == "추가하기" {
                        return Reactor.Action.addTodo(todo)
                    } else {
                        return Reactor.Action.editTodo(todo)
                    }
                }
                
                return Reactor.Action.none
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
                self?.addButton.setTitle("수정하기", for: .normal)
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
