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
        self.scrollEnabled = true
        self.scrollDirection = .vertical
        self.scope = .month
        self.appearance.weekdayTextColor = .primaryColor
        self.appearance.headerTitleColor = .primaryColor
        self.appearance.titleDefaultColor = .label
        self.placeholderType = .none
        
        updateCaledanrFont()
    }
    
    func updateCaledanrFont() {
        let fontName = UserInfoService.shared.getFontName()
        if fontName == "normal" {
            self.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
            self.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
            self.appearance.titleFont = UIFont.systemFont(ofSize: 12)
        } else {
            self.appearance.weekdayFont = UIFont(name: fontName, size: 15)
            self.appearance.headerTitleFont = UIFont(name: fontName, size: 20)
            self.appearance.titleFont = UIFont(name: fontName, size: 12)
        }
    }
}
