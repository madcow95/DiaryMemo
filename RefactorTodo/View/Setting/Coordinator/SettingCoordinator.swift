import UIKit

final class SettingCoordinator: Coordinator {
    weak var parentCoordinator: HomeCoordinator?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = SettingReactor(settingCoordinator: self)
        let settingVC = SettingViewController()
        settingVC.reactor = reactor
        
        navigationController.pushViewController(settingVC, animated: true)
    }
    
    // 개인정보 처리방침 화면으로 이동
    func showPrivacyPolicy() {
        let urlString = "https://fish-monitor-e2d.notion.site/8b8d7037394a46258fb344590b48c69f?pvs=4"
        let privacyPolicyVC = PrivacyPolicyViewController(urlString: urlString)
        let navController = UINavigationController(rootViewController: privacyPolicyVC)
        navigationController.present(navController, animated: true, completion: nil)
    }
    
    // 폰트 설정 화면으로 이동
    func showFontStyleView() {
        let reactor = SettingFontReactor(parentCoordinator: self)
        let fontView = SettingFontViewController()
        fontView.reactor = reactor
        
        navigationController.pushViewController(fontView, animated: true)
    }
}
