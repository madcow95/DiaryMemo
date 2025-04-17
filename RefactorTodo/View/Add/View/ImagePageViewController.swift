import UIKit
import SnapKit

final class ImagePageViewController: UIPageViewController {
    private let images: [UIImage]
    private var currentIndex: Int = 0
    
    init(images: [UIImage], initialIndex: Int) {
        self.images = images
        self.currentIndex = initialIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let initialVC = createImageViewController(for: currentIndex) {
            setViewControllers([initialVC], direction: .forward, animated: false)
        }
    }
    
    private func createImageViewController(for index: Int) -> ImageViewerController? {
        guard index >= 0, index < images.count else { return nil }
        
        return ImageViewerController(image: images[index])
    }
}

extension ImagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ImageViewerController else {
            return nil
        }
        guard let currentIndex = images.firstIndex(where: { $0 === currentVC.image }) else {
            return nil
        }
        return createImageViewController(for: currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ImageViewerController else {
            return nil
        }
        guard let currentIndex = images.firstIndex(where: { $0 === currentVC.image }) else {
            return nil
        }
        return createImageViewController(for: currentIndex + 1)
    }
}
