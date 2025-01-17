import UIKit

class SearchDiaryCoordinator: Coordinator {
    var parentCoordinator: HomeCoordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = SearchDiaryReactor()
        reactor.homeCoordinator = parentCoordinator
        let vc = SearchDiaryViewController()
        vc.reactor = reactor
        
        navigationController.pushViewController(vc, animated: true)
    }
}
