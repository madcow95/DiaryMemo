import UIKit

// String을 Date방식으로 전환
extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.date(from: self)
    }
}
