import UIKit

class UserInfoService {
    static let shared = UserInfoService()
    private let defaults = UserDefaults.standard
    
    init() {
        if defaults.object(forKey: "savedFontSize") == nil {
            defaults.set(FontCase.normal.rawValue, forKey: "savedFontSize")
        }
        if defaults.object(forKey: "savedFontName") == nil {
            defaults.set("normal", forKey: "savedFontName")
        }
    }
    
    // 폰트 사이즈 저장
    func saveFontSize(fontCase: FontCase) {
        defaults.set(fontCase.rawValue, forKey: "savedFontSize")
    }
    
    // 폰트 사이즈 불러오기
    func getFontSize() -> FontCase {
        let fontIndex = defaults.integer(forKey: "savedFontSize")
        
        return FontCase.allCases[fontIndex]
    }
    
    // 폰트명 저장
    func saveFontName(name: String) {
        defaults.set(name, forKey: "savedFontName")
    }
    
    // 폰트명 불러오기
    func getFontName() -> String {
        return defaults.string(forKey: "savedFontName") ?? "normal"
    }
}
