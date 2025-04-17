import UIKit
import SnapKit
import ReactorKit
import RxSwift

final class SettingViewController: TodoViewController {
    var disposeBag = DisposeBag()
    let appearanceMode = UserInfoService.shared.getAppearance()
    
    private lazy var settingTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        table.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureTable()
    }
    
    private func configureTable() {
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension SettingViewController: View {
    func bind(reactor: SettingReactor) {
        reactor.state.map { $0.themeChanged }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { _ in
                self.viewIsAppearing(true)
                for (index, _) in reactor.currentState.cellLabels.enumerated() {
                    if index == 2 {
                        guard let cell = self.settingTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SettingTableViewCell else { return }
                        
                        cell.contentView.backgroundColor = UserInfoService.shared.getAppearance() == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
                    } else {
                        self.settingTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                }
                self.settingTableView.backgroundColor = UserInfoService.shared.getAppearance() == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.cellLabels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell, let reactor = self.reactor else {
            return UITableViewCell()
        }
        
        let title = reactor.currentState.cellLabels[indexPath.row]
        let image = reactor.currentState.cellImage[indexPath.row]
        cell.configureCell(title: title, imageName: image, cellType: indexPath.row == 2 ? .toggle : .chevron)
        
        if indexPath.row == 2 {
            cell.changeAppearanceMode = {
                self.reactor?.action.onNext(.changeAppearanceTheme)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.item {
        case 0:
            reactor?.action.onNext(.showFontSettingView)
        case 1:
            reactor?.action.onNext(.presentPrivatePolicy)
        case 2:
            reactor?.action.onNext(.changeAppearanceTheme)
            guard let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell else { return }
            
            cell.changeDarkMode()
        default:
            break
        }
    }
}
