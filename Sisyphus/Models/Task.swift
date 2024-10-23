import Foundation

struct Todo: Identifiable, Schedulable {
    let id: UUID
    let name: String
    let description: String?
    let scheduledAt: Date?
    let completedAt: Date?
    
    init(id: UUID = UUID(), name: String, description: String?, scheduledAt: Date? = nil, completedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.scheduledAt = scheduledAt
        self.completedAt = completedAt
    }
    
    func isComplete() -> Bool {
        return self.completedAt != nil
    }
    
    func isOverdue() -> Bool {
        guard let scheduledAt = scheduledAt else {
            return false
        }
        return !isComplete() && scheduledAt < Date.now
    }
    
    var start: Date {
        scheduledAt!
    }
    
    
}

#if DEBUG

extension Todo {
    
    func isScheduledForToday() -> Bool {
        guard let scheduledAt = scheduledAt else {
            return true  // Exclude unscheduled todos
        }
        return Calendar.current.isDateInToday(scheduledAt)
    }
    
    static let sampleData: [Todo] = [
        Todo(name: "Buy groceries",
             description: "Milk, bread, and eggs from the market",
             scheduledAt: nil,  // Unscheduled task
             completedAt: nil),
        Todo(name: "Workout",
             description: "30-minute run at the park",
             scheduledAt: Date().addingTimeInterval(3600),  // Scheduled for 1 hour from now
             completedAt: nil),
        Todo(name: "Read a book",
             description: "Finish chapter 3 of 'The Hobbit'",
             scheduledAt: nil,  // Unscheduled task
             completedAt: nil),
        Todo(name: "Plan vacation",
             description: "Look for flights to Madrid",
             scheduledAt: Date().addingTimeInterval(10800),  // 3 hours from now
             completedAt: nil),
        Todo(name: "Code Review",
             description: "Review pull request #42",
             scheduledAt: Date().addingTimeInterval(-7200),  // 2 hours ago
             completedAt: Date(timeIntervalSinceNow: -3600)),  // Completed 1 hour ago
        Todo(name: "Dinner with friends",
             description: "At Luigi’s Italian restaurant",
             scheduledAt: Date().addingTimeInterval(5400),  // 1.5 hours from now
             completedAt: nil),
    ]
}

#endif
