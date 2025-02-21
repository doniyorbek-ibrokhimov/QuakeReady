import SwiftData
import Foundation

/// A model representing a completed drill achievement and its performance metrics.
@Model
class DrillAchievement {
    /// The type of drill completed, stored as DrillType's raw value.
    let drillType: String
    
    /// The date when the drill was completed.
    let completedDate: Date
    
    /// The accuracy score achieved during the drill, represented as a percentage (0-100).
    let accuracy: Double
    
    /// The time taken to complete the drill, measured in seconds.
    let timeTaken: Int
    
    /// Creates a new drill achievement record.
    /// - Parameters:
    ///   - drillType: The type of drill completed (stored as DrillType's raw value)
    ///   - completedDate: The date when the drill was completed
    ///   - accuracy: The accuracy score achieved (0-100)
    ///   - timeTaken: The time taken to complete the drill in seconds
    init(drillType: String, completedDate: Date, accuracy: Double, timeTaken: Int) {
        self.drillType = drillType
        self.completedDate = completedDate
        self.accuracy = accuracy
        self.timeTaken = timeTaken
    }
} 