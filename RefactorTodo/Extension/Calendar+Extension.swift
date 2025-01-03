import FSCalendar
import UIKit

// FSCalendar 라이브러리 -> UIViewController에서 사용하면 코드가 길어져서 분리
class TodoCalendar: FSCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialCalendar()
    }
    
    func initialCalendar() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.locale = Locale(identifier: "ko_KR")
        self.layer.cornerRadius = 8
        self.scrollEnabled = true
        self.scrollDirection = .vertical
        self.scope = .month
        self.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.appearance.weekdayTextColor = .systemGreen
        self.appearance.headerTitleColor = .systemGreen
        self.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.appearance.todayColor = .systemGreen
//        self.appearance.selectionColor = .systemGreen.withAlphaComponent(0.5)
//        self.appearance.selectionColor = .clear
    }
}
