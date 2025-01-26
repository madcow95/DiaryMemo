//
//  Todo+CoreDataClass.swift
//  RefactorTodo
//
//  Created by MadCow on 2025/1/9.
//
//

import UIKit
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

}

struct TodoModel {
    let date: String
    let content: String
    let emotion: String
    var images: [Data]?
}

extension Todo {
    func toTodoModel() -> TodoModel {
        return TodoModel(date: self.date,
                         content: self.content,
                         emotion: self.emotion,
                         images: self.images)
    }
}

// 폰트 설정을 위한 enum 케이스
public enum FontCase: Int, CaseIterable {
    case smallest
    case smaller
    case small
    case normal
    case large
    case larger
    case largest
    
    var fontSize: CGFloat {
        get {
            switch self {
            case .largest:
                return 22
            case .larger:
                return 20
            case .large:
                return 18
            case .normal:
                return 16
            case .small:
                return 14
            case .smaller:
                return 12
            case .smallest:
                return 10
            }
        }
    }
    
    init?(index: Int) {
        self.init(rawValue: index)
    }
    
    enum SelectCase {
        case minus
        case plus
    }
    
    func updateCaseBy(selectCase: SelectCase) -> FontCase {
        switch selectCase {
        case .minus:
            switch self {
            case .largest:
                return .larger
            case .larger:
                return .large
            case .large:
                return .normal
            case .normal:
                return .small
            case .small:
                return .smaller
            case .smaller:
                return .smallest
            default:
                break
            }
        case .plus:
            switch self {
            case .larger:
                return .largest
            case .large:
                return .larger
            case .normal:
                return .large
            case .small:
                return .normal
            case .smaller:
                return .small
            case .smallest:
                return .smaller
            default:
                break
            }
        }
        return .normal
    }
}
