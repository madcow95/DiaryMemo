import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SplashViewController: TodoViewController {
    var disposeBag = DisposeBag()
    
    private lazy var splashImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "splashImage")
        imgView.snp.makeConstraints {
            $0.width.height.equalTo(self.view.frame.width / 3)
        }
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private let splashLabel = TodoLabel(text: "DiaryMemo", fontSize: 35, fontWeight: .bold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .splashColor
        navigationController?.navigationBar.isHidden = true
        configureUI()
        dismissSplashView()
    }
    
    func configureUI() {
        setSplashImage()
        setSplashLogo()
    }
    
    func setSplashImage() {
        view.addSubview(splashImage)
        
        splashImage.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
    }
    
    func setSplashLogo() {
        view.addSubview(splashLabel)
        
        splashLabel.snp.makeConstraints {
            $0.top.equalTo(splashImage.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func dismissSplashView() {
        if let reactor = reactor {
            reactor.action.on(.next(.moveToHomeView))
        }
    }
}


extension SplashViewController: View {
    func bind(reactor: SplashReactor) {
        
    }
}
