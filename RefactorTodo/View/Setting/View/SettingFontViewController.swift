import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SettingFontViewController: TodoViewController {
    var disposeBag = DisposeBag()
    let appearanceMode = UserInfoService.shared.getAppearance()
    private lazy var previewContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 10
        container.backgroundColor = appearanceMode == "Dark" ? .lightGray : .white
        
        return container
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "emoji_8")
        
        return imageView
    }()
    private lazy var dateLabel = TodoLabel(text: Date().dateToString(includeDay: .dayOfWeek),
                                           textColor: appearanceMode == "Dark" ? .white : .lightGray)
    private let firstPreviewLabel = TodoLabel(text: "일기를 쓰는 습관 :)")
    private let secondPreviewLabel = TodoLabel(text: "변경된 폰트 사이즈가 표시됩니다")
    private lazy var slider = FontSizeSlider(count: 7,
                                             vc: self)
    private lazy var fontTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(FontTableViewCell.self, forCellReuseIdentifier: "FontTableViewCell")
        table.layer.cornerRadius = 10
        table.backgroundColor = appearanceMode == "Dark" ? .lightGray : .white
        
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.loadFontInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        self.title = "글자 스타일"
        configurePreview()
        configureSlider()
        configureTable()
    }
    
    func configurePreview() {
        view.addSubview(previewContainer)
        previewContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.height.equalTo(180)
        }
        
        previewContainer.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalTo(previewContainer.snp.top).offset(10)
            $0.centerX.equalTo(previewContainer.snp.centerX)
            $0.height.equalTo(50)
        }
        
        previewContainer.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.centerX.equalTo(previewContainer.snp.centerX)
        }
        
        previewContainer.addSubview(firstPreviewLabel)
        firstPreviewLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.left.equalTo(previewContainer.snp.left).offset(10)
            $0.right.equalTo(previewContainer.snp.right).offset(-10)
        }
        
        previewContainer.addSubview(secondPreviewLabel)
        secondPreviewLabel.snp.makeConstraints {
            $0.top.equalTo(firstPreviewLabel.snp.bottom)
            $0.left.equalTo(previewContainer.snp.left).offset(10)
            $0.right.equalTo(previewContainer.snp.right).offset(-10)
        }
        secondPreviewLabel.numberOfLines = 0
    }
    
    func configureSlider() {
        view.addSubview(slider)
        slider.snp.makeConstraints {
            $0.top.equalTo(previewContainer.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.right.equalTo(view.snp.right).offset(-10)
        }

        view.layoutIfNeeded()
        
        slider.drawCircle(lineWidth: slider.hLine.frame.width,
                          index: reactor!.currentState.currentFontSize.rawValue)
        slider.addButtonAction()
    }
    
    func configureTable() {
        view.addSubview(fontTableView)
        fontTableView.snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom).offset(40)
            $0.left.right.equalTo(slider)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
    }
}

extension SettingFontViewController: View {
    func bind(reactor: SettingFontReactor) {
        reactor.state.map { $0.currentFontSize.rawValue }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] idx in
                guard let self = self, self.slider.circles.count > 0 else { return }
                self.slider.updateCircle(index: idx)
                self.dateLabel.updateFontSize()
                self.firstPreviewLabel.updateFontSize()
                self.secondPreviewLabel.updateFontSize()
            }
            .disposed(by: disposeBag)
    }
}

extension SettingFontViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.fonts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FontTableViewCell", for: indexPath) as? FontTableViewCell else {
            return UITableViewCell()
        }
        
        if let fontItem = reactor?.currentState.fonts[indexPath.row] {
            cell.configureCell(title: fontItem.1,
                               fontName: fontItem.0,
                               fontSelected: indexPath.item == reactor?.currentState.fontIndex)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if let fontName = self.reactor?.currentState.fonts[indexPath.row] {
                UserInfoService.shared.saveFontName(name: fontName.0)
                self.dateLabel.updateFontSize()
                self.firstPreviewLabel.updateFontSize()
                self.secondPreviewLabel.updateFontSize()
                if let cell = tableView.cellForRow(at: indexPath) as? FontTableViewCell,
                   let prevCell = tableView.cellForRow(at: IndexPath(item: self.reactor?.currentState.fontIndex ?? 0, section: 0))  as? FontTableViewCell {
                    prevCell.checkImageView.isHidden = true
                    cell.checkImageView.isHidden = false
                }
                self.reactor?.action.onNext(.updateFontIndex(indexPath.item))
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
