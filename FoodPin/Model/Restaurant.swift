//
//  Restaurant.swift
//  FoodPin
//
//  Created by Simon Ng on 16/10/2022.
//
import Combine
import CoreData

public class Restaurant: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var location: String
    @NSManaged var phone: String
    @NSManaged var summary: String
    @NSManaged var image: Data
    @NSManaged var isFavorite: Bool
    @NSManaged var ratingText: String?
    
}

extension Restaurant {
    
    /**
     CaseIterable, 可以迭代项目的接口
     */
    enum Rating: String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var image: String {
            switch self {
                case .awesome: return "love"
                case .good: return "cool"
                case .okay: return "happy"
                case .bad: return "sad"
                case .terrible: return "angry"
            }
        }
    }
    
    var rating: Rating? {
        get {
            guard let ratingText = ratingText else {
                return nil
            }
            
            return Rating(rawValue: ratingText)
        }
        
        set {
            self.ratingText = newValue?.rawValue
        }
    }
    
}
