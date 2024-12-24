import FSCalendar
import UIKit

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
        self.delegate = self
        self.dataSource = self
        self.locale = Locale(identifier: "ko_KR")
        self.layer.cornerRadius = 8
        self.scrollEnabled = true
        self.scrollDirection = .horizontal
        self.scope = .month
        self.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.appearance.weekdayTextColor = .systemGreen
        self.appearance.headerTitleColor = .systemGreen
        self.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.appearance.todayColor = .systemGreen
        self.appearance.selectionColor = .systemGreen.withAlphaComponent(0.5)
    }
}

extension TodoCalendar: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("📅 :\(date) 날짜 선택")
    }
    
    // 선택된 날짜를 선택했을 때 호출
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("📅 :\(date) 날짜 선택 해제")
    }
    
    // 선택된 날짜 테두리 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor.systemGreen
    }
    
    // 페이지 변화에 대한 이벤트 - 스크롤
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(calendar.currentPage)
    }
}
