import UIKit

// String을 Date방식으로 전환
extension String {
    /// Format에 따른 String -> Date 형 변환
    func stringToDate(format: String = "yyyy.MM.dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
}
