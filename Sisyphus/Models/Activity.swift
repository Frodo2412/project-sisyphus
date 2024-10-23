import Foundation

struct Activity: Identifiable, Schedulable {
    let id: UUID
    let name: String
    let description: String?
    let startDate: Date
    let endDate: Date
    
    init(id: UUID = UUID(), name: String, description: String?, startDate: Date, endDate: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var start: Date {
        startDate
    }
}

#if DEBUG

extension Activity {
    
    func isScheduledForToday() -> Bool {
        return Calendar.current.isDateInToday(startDate) || Calendar.current.isDateInToday(endDate)
    }
    
    static let sampleActivities: [Activity] = [
        Activity(
            name: "Morning Run",
            description: "A quick 5K run around the park",
            startDate: Date().addingTimeInterval(-3600), // 1 hour ago
            endDate: Date()
        ),
        Activity(
            name: "Team Meeting",
            description: "Discuss project updates and timelines",
            startDate: Date().addingTimeInterval(-1600),  // 1 hour from now
            endDate: Date().addingTimeInterval(7200)      // 2 hours from now
        ),
        Activity(
            name: "Lunch with Sarah",
            description: "Meeting at the local sushi bar",
            startDate: Date().addingTimeInterval(10800),  // 3 hours from now
            endDate: Date().addingTimeInterval(14400)     // 4 hours from now
        ),
        Activity(
            name: "Yoga Class",
            description: "Evening relaxation and stretching session",
            startDate: Date().addingTimeInterval(18000),  // 5 hours from now
            endDate: Date().addingTimeInterval(19800)     // 5.5 hours from now
        ),
        Activity(
            name: "Dinner Party",
            description: "Hosting friends at my place",
            startDate: Date().addingTimeInterval(21600),  // 6 hours from now
            endDate: Date().addingTimeInterval(25200)     // 7 hours from now
        ),
        Activity(
            name: "Weekend Trip",
            description: "A relaxing weekend getaway in the mountains",
            startDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, // 2 days from now
            endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date())!   // 4 days from now
        )
    ]
}

#endif
