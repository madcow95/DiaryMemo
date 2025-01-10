import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
    }
    
    func setImage(image: UIImage, key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeImage(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
