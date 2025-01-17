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
    
    func saveFontSize(fontCase: FontCase) {
        defaults.set(fontCase.rawValue, forKey: "savedFontSize")
    }
    
    func getFontSize() -> FontCase {
        let fontIndex = defaults.integer(forKey: "savedFontSize")
        
        return FontCase.allCases[fontIndex]
    }
    
    func saveFontName(name: String) {
        defaults.set(name, forKey: "savedFontName")
    }
    
    func getFontName() -> String {
        return defaults.string(forKey: "savedFontName") ?? "normal"
    }
}
