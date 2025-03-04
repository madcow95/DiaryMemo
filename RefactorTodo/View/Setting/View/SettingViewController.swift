import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SettingViewController: TodoViewController {
    var disposeBag = DisposeBag()
    
    private lazy var settingTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        table.backgroundColor = .todoBackgroundColor
        
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
    
    func configureUI() {
        configureTable()
    }
    
    func configureTable() {
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension SettingViewController: View {
    func bind(reactor: SettingReactor) {
        
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.cellLabels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        if let title = reactor?.currentState.cellLabels[indexPath.item],
            let image = reactor?.currentState.cellImage[indexPath.item] {
            cell.configureCell(title: title, imageName: image)
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
        default:
            break
        }
    }
}
