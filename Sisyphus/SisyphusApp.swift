import SwiftUI

@main
struct SisyphusApp: App {
    
    let todos = Todo.sampleData
    let activities = Activity.sampleActivities
    
    var body: some Scene {
        WindowGroup {
            TodayView(todos: todos, activities: activities)
        }
    }
}
