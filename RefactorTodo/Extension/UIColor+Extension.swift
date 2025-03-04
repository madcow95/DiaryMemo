import UIKit

// 앱 전용 색상 정리
extension UIColor {
    static var todoBackgroundColor: UIColor {
        get {
            var rgbValue: UInt64 = 0
            Scanner(string: "F5F1EB").scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    static var primaryColor: UIColor {
        get {
            var rgbValue: UInt64 = 0
            Scanner(string: "BD8125").scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    static var splashColor: UIColor {
        get {
            return UIColor(red: 209/255, green: 205/255, blue: 197/255, alpha: 1)
        }
    }
}
