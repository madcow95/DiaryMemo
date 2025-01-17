import UIKit

class UserInfoService {
    static let shared = UserInfoService()
    private let defaults = UserDefaults.standard
    
    init() {
        // 초기화 시점에 기본값 설정
        if defaults.object(forKey: "savedFontSize") == nil {
            defaults.set(FontCase.normal.rawValue, forKey: "savedFontSize")
        }
    }
    
    func saveFontSize(fontCase: FontCase, key: String) {
        defaults.set(fontCase.rawValue, forKey: key)
    }
    
    func getFontSize(key: String) -> FontCase {
        let fontIndex = defaults.integer(forKey: key)
        
        return FontCase.allCases[fontIndex]
    }
}
