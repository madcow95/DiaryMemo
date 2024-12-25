import UIKit
import SnapKit
import ReactorKit

class EmotionViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
    }
}

extension EmotionViewController: View {
    func bind(reactor: EmotionReactor) {
        
    }
}
