import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SplashViewController: TodoViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissSplashView()
    }
    
    func dismissSplashView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.reactor?.splashCoordinator?.moveToHomeView()
        }
    }
}


extension SplashViewController: View {
    func bind(reactor: SplashReactor) {
        
    }
}
