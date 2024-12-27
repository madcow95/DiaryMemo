import Foundation

extension Date {
    // 현재 날짜를 String방식으로 변환
    // MARK: TODO - 요일을 포함할지 안할지에 대한 분기처리 할 것
    func dateToString(date: Date? = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd EEEE"
        
        return dateFormatter.string(from: date ?? Date())
    }
}
