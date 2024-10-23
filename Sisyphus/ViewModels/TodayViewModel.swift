import SwiftUI
import Combine

class TodayViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var activities: [Activity]
    
    // Initialize with sample or real data
    init(todos: [Todo], activities: [Activity]) {
        self.todos = todos
        self.activities = activities
    }
    
    // Filter scheduled todos
    var scheduledTodos: [Todo] {
        todos.filter { $0.scheduledAt != nil }
    }
    
    // Filter unscheduled todos
    var unscheduledTodos: [Todo] {
        todos.filter { $0.scheduledAt == nil }
    }
    
    // Combine and sort scheduled todos and activities
    var scheduledItems: [any Schedulable] {
        let mappedActivities: [any Schedulable] = activities
        let mappedTodos: [any Schedulable] = scheduledTodos
        let combined = mappedActivities + mappedTodos
        return combined.sorted { lhs, rhs in
            lhs.start < rhs.start
        }
    }
}

#if DEBUG

extension TodayViewModel {
    
    static let sample = TodayViewModel(
        todos: Todo.sampleData.filter { $0.isScheduledForToday() },
        activities:Activity.sampleActivities.filter { $0.isScheduledForToday() }
    )
}

#endif
