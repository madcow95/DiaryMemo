import UIKit

// 공통으로 사용하는 UIViewController
class TodoViewController: UIViewController {
    
    let appearanceMode = UserInfoService.shared.getAppearance()
    /// Lifecycle이 viewIsAppearing이 동작을 할 때 tabbar, 뒤로가기 버튼 등의 색상을 primary Color로 변경
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        if let navigationVC = self.navigationController {
            let navBar = navigationVC.navigationBar
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
            appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.setBackIndicatorImage(
                UIImage(systemName: "chevron.backward")?
                    .withTintColor(.primaryColor, renderingMode: .alwaysOriginal),
                transitionMaskImage: UIImage(systemName: "chevron.backward")?
                    .withTintColor(.primaryColor, renderingMode: .alwaysOriginal)
            )

            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.isTranslucent = false
        }
        
        if let tabBarVC = self.tabBarController {
            let tabBar = tabBarVC.tabBar
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundColor = appearanceMode == "Dark" ? .darkBackgroundColor : .lightBackgroundColor
            
            tabBar.standardAppearance = tabAppearance
            tabBar.scrollEdgeAppearance = tabAppearance
            tabBar.isTranslucent = false
        }
        
        setAppearance()
    }
    
    /// LifeCycle이 viewDidLoad의 동작을 할 때 배경 색상을 변경함
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightBackgroundColor
    }
}

// UIViewController에서 바로 사용할 수 있는 alert
extension UIViewController {
    func showAlert(alertTitle: String, msg: String? = nil, confirm: String, hideCancel: Bool? = false, confirmAction: (() -> Void)?, cancelAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: alertTitle, message: msg, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirm, style: .default) { _ in
            confirmAction?()
        }
        alertController.addAction(confirmAction)
        
        if hideCancel != true {
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                cancelAction?()
            }
            alertController.addAction(cancelAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setAppearance() {
        
        switch UserInfoService.shared.getAppearance() {
        case "Light":
            self.overrideUserInterfaceStyle = .light
            self.view.backgroundColor = .lightBackgroundColor
        case "Dark":
            self.overrideUserInterfaceStyle = .dark
            self.view.backgroundColor = .darkBackgroundColor
        default:
            break
        }
    }
}
