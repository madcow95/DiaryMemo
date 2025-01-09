import UIKit
import FirebaseStorage
import ReactorKit

class FirebaseService {
    static let shared = FirebaseService()
    
    func savePhotos(photoInfo: [(UIImage, String)], date: String, completion: @escaping (Result<[String], Error>) -> Void) {
        var photoURLs: [String] = []
        let dispatchGroup = DispatchGroup()
        print(photoInfo)
        photoInfo.enumerated().forEach { (idx, info) in
            dispatchGroup.enter()
            
            guard let imageData = info.0.jpegData(compressionQuality: 0.5) else {
                dispatchGroup.leave()
                return
            }
            
            let storageRef = Storage.storage().reference()
            let imageRef = storageRef.child("\(date)/\(info.1).png")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            imageRef.putData(imageData, metadata: metaData) { metaData, error in
                if let error = error {
                    dispatchGroup.leave()
                    completion(.failure(error))
                    
                    return
                }
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        dispatchGroup.leave()
                        completion(.failure(error))
                        
                        return
                    }
                    
                    if let url = url?.absoluteString {
                        photoURLs.append(url)
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(photoURLs))
        }
    }
    
    func loadImages(urls: [String]) -> Observable<[UIImage]> {
        return Observable.create { observer in
            let dispatchGroup = DispatchGroup()
            var images: [UIImage] = []
            
            for urlString in urls {
                dispatchGroup.enter()
                
                let gsReference = Storage.storage().reference(forURL: urlString)
                
                gsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    defer { dispatchGroup.leave() }
                    
                    if let error = error {
                        print("Firebase storage download error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        images.append(image)
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                observer.onNext(images)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
