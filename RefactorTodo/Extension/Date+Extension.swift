import Foundation

extension Date {
    
    func dateToString(date: Date? = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd EEEE"
        
        return dateFormatter.string(from: date ?? Date())
    }
}
