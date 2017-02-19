import UIKit

public struct PennyPincherTemplate {
    public let id: String
    public let points: [CGPoint]
    
    init(id: String, points: [CGPoint]) {
        self.id = id
        self.points = points
    }
    
    init(dictionary: [String: Any]) {
        if let identifier = dictionary["id"] as? String {
            self.id = identifier
        } else {
            self.id = ""
        }
        
        if let storedPoints = dictionary["points"] as? [CGPoint] {
            self.points = storedPoints
        } else {
            self.points = [CGPoint]()
        }
    }
    
    var dictionary : [String : Any] {
        get {
            return [ "id" : id,
                     "points" : points ]
        }
    }
}
