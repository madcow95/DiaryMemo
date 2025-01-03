import Foundation

extension Date {
    enum IncludeDay {
        case year
        case month
        case day
        case dayOfWeek
    }
    // 현재 날짜를 String방식으로 변환
    // MARK: TODO - 요일을 포함할지 안할지에 대한 분기처리 할 것
    func dateToString(includeDay: IncludeDay = .dayOfWeek) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        var format: String = ""
        switch includeDay {
        case .year:
            format = "yyyy"
        case .month:
            format = "yyyy.MM"
        case .day:
            format = "yyyy.MM.dd"
        case .dayOfWeek:
            format = "yyyy.MM.dd EEEE"
        }
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
