import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController()
        let reactor = HomeReactor(homeCoordinator: self)
        homeVC.reactor = reactor
        
        navigationController.viewControllers = [homeVC]
    }
    
    // 일기 작성 화면으로 이동
    func moveToAddTodo(selected date: Date) {
        let addTodoCoordinator = AddTodoCoordinator(navigationController: navigationController,
                                                    selectedDate: date)
        childCoordinators.append(addTodoCoordinator)
        addTodoCoordinator.parentCoordinator = self
        addTodoCoordinator.start()
    }
    
    // 설정 화면으로 이동
    func moveToSetting() {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        childCoordinators.append(settingCoordinator)
        settingCoordinator.parentCoordinator = self
        settingCoordinator.start()
    }
    
    // 일기 검색 화면으로 이동
    func moveToSearch() {
        let searchCoordinator = SearchDiaryCoordinator(navigationController: navigationController)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.parentCoordinator = self
        searchCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let idx = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: idx)
        }
    }
}
