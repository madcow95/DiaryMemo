import UIKit
import Photos
import PhotosUI

final class EmotionCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: AddTodoCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func showPhotoLibaryView() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        // 갤러리 접근 권한에 따른 분기처리
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.presentImagePicker()
                    }
                }
            }
        case .authorized:
            presentImagePicker()
        case .denied, .restricted:
            navigationController.showAlert(alertTitle: "갤러리 접근 권한이 필요합니다",
                                           msg: "설정에서 갤러리 접근 권한을 허용해주세요",
                                           confirm: "설정으로 이동") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        default:
            break
        }
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = navigationController.viewControllers.last as? PHPickerViewControllerDelegate
        navigationController.present(picker, animated: true)
    }
}
