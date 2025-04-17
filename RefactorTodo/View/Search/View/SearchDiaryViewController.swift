import UIKit
import SnapKit
import RxSwift
import ReactorKit

final class SearchDiaryViewController: TodoViewController {
    var disposeBag: DisposeBag = DisposeBag()
    private let appearanceMode = UserInfoService.shared.getAppearance()
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var resultTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        table.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
        table.layer.cornerRadius = 10
        
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.searchDiary(searchController.searchBar.text ?? ""))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureSearchBar()
        configureTable()
    }
    
    private func configureSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "일기 검색"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
    }
    
    private func configureTable() {
        resultTableView.rowHeight = UITableView.automaticDimension
        resultTableView.estimatedRowHeight = 400
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchDiaryViewController: View {
    func bind(reactor: SearchDiaryReactor) {
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { .searchDiary($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.searchedDiary }
            .bind(onNext: { [weak self] todos in
                guard let self = self else { return }
                self.resultTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SearchDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.searchedDiary.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        if let todo = reactor?.currentState.searchedDiary[indexPath.row] {
            cell.configureCell(todo: todo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: TODO - 화면 이동해서 정보 업데이트 기능 만들어야함
        if let todo = reactor?.currentState.searchedDiary[indexPath.item] {
            reactor?.homeCoordinator?.moveToAddTodo(selected: todo.date.stringToDate() ?? Date())
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
