import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
    }
    
    // key로 이미지 저장
    func setImage(image: UIImage, key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    // key로 이미지 불러오기
    func getImage(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // key에 저장된 캐시 삭제
    func removeImage(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    // 캐시에 저장된 이미지 모두 삭제
    func clearCache() {
        cache.removeAllObjects()
    }
}
