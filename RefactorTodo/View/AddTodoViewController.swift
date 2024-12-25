import UIKit
import SnapKit
import ReactorKit

class AddTodoViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.showEmotionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension AddTodoViewController: View {
    func bind(reactor: AddTodoReactor) {
        
    }
}
