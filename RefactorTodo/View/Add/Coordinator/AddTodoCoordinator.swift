import UIKit
import Photos
import PhotosUI

final class AddTodoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoordinator?
    let selectedDate: Date
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, selectedDate: Date) {
        self.navigationController = navigationController
        self.selectedDate = selectedDate
    }
    
    // 일기 작성 화면으로 이동
    func start() {
        let reactor = AddTodoReactor(addTodoCoordinator: self, selectedDate: selectedDate)
        let addVC = AddTodoViewController()
        addVC.reactor = reactor
        
        navigationController.pushViewController(addVC, animated: true)
    }
    
    // 감정 선택 화면으로 이동
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
    
    // 사용자 갤러리 화면으로 이동
    func showPhotoLibaryView(photo count: Int) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        // 갤러리 접근 권한에 따른 분기처리
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
    
    // 갤러리 접근 권한 허용일 때 실제로 화면에 present
    private func presentImagePicker(photo count: Int) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 5 - count
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = navigationController.viewControllers.last as? PHPickerViewControllerDelegate
        navigationController.present(picker, animated: true)
    }
    
    // UICollectionViewCell을 선택했을 때 전체화면으로 이미지를 볼 수 있는 화면으로 이동
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
