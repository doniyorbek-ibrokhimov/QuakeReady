import SwiftData
import Foundation

@Model
class DrillAchievement {
    let drillType: String  // Store DrillType's rawValue
    let completedDate: Date
    let accuracy: Double
    let timeTaken: Int
    
    init(drillType: String, completedDate: Date, accuracy: Double, timeTaken: Int) {
        self.drillType = drillType
        self.completedDate = completedDate
        self.accuracy = accuracy
        self.timeTaken = timeTaken
    }
} 