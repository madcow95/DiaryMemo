import UIKit
import SnapKit
import ReactorKit

class ImageViewerController: UIViewController {
    var disposeBag = DisposeBag()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        scrollView.delegate = nil
        imageView.image = nil
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
