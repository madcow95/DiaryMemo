import UIKit
import Photos
import PhotosUI

final class AddTodoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoorinator?
    let selectedDate: Date
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, selectedDate: Date) {
        self.navigationController = navigationController
        self.selectedDate = selectedDate
    }
    
    func start() {
        let reactor = AddTodoReactor(addTodoCoordinator: self, selectedDate: selectedDate)
        let addVC = AddTodoViewController()
        addVC.reactor = reactor
        navigationController.pushViewController(addVC, animated: true)
    }
    
    func showEmotionSelectView(date: Date) {
        let addTodoReactor = navigationController.viewControllers
            .compactMap { ($0 as? AddTodoViewController)?.reactor }
            .first
        let emotionReactor = EmotionReactor(selectedDate: date)
        emotionReactor.addTodoReactor = addTodoReactor
        let emotionVC = EmotionViewController()
        emotionVC.reactor = emotionReactor
        
        navigationController.present(emotionVC, animated: true)
    }
    
    func showPhotoLibaryView(photo count: Int) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.presentImagePicker(photo: count)
                    }
                }
            }
        case .authorized:
            presentImagePicker(photo: count)
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
    
    private func presentImagePicker(photo count: Int) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 5 - count
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = navigationController.viewControllers.last as? PHPickerViewControllerDelegate
        navigationController.present(picker, animated: true)
    }
    
    func showImageViewer(images: [UIImage], index: Int) {
        let pageVC = ImagePageViewController(images: images, initialIndex: index)
        let navigationVC = UINavigationController(rootViewController: pageVC)
        navigationVC.modalPresentationStyle = .pageSheet
        
        self.navigationController.present(navigationVC, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
