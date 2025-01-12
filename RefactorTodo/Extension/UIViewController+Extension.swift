import UIKit

class TodoViewController: UIViewController {
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        if let navigationVC = self.navigationController {
            let navBar = navigationVC.navigationBar
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .todoBackgroundColor
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
            tabAppearance.backgroundColor = .todoBackgroundColor
            
            tabBar.standardAppearance = tabAppearance
            tabBar.scrollEdgeAppearance = tabAppearance
            tabBar.isTranslucent = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.todoBackgroundColor
    }
}

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
}
