import SwiftUI

struct TodayView: View {
    
    let todos: [Todo]
    let activities: [Activity]
    
    private var scheduledTodos: [Todo] {
        todos.filter { $0.scheduledAt != nil }
    }
    private var unscheduledTodos: [Todo] {
        todos.filter { $0.scheduledAt == nil }
    }
    
    private var scheduled: [AnySchedulable] {
        (activities.map { AnySchedulable($0) } + scheduledTodos.map { AnySchedulable($0) })
            .sorted { $0.content.start < $1.content.start }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Agenda")) {
                    ForEach(scheduled) { schedulable in
                        if let activity = schedulable.content as? Activity {
                            ActivityCard(activity: activity)
                        } else if let todo = schedulable.content as? Todo {
                            TodoCard(todo: todo)
                        }
                    }
                }
                Section(header: Text("Sometime today")) {
                    ForEach(unscheduledTodos) { todo in
                        TodoCard(todo: todo)
                    }
                }
            }
            .navigationTitle("Today")
        }
    }
}

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"  // e.g., "2:30 PM"
    return formatter
}()

struct TodoCard: View {
    
    var todo: Todo
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: todo.isComplete() ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isComplete() ? .green : .gray)
                    .imageScale(.large)
            }
            
            VStack(alignment: .leading) {
                Text(todo.name)
                    .font(.headline)
                    .strikethrough(todo.isComplete())
                    .foregroundColor(todo.isComplete() ? .secondary : .primary)
                HStack {
                    if let completedAt = todo.completedAt {
                        Text(formatter.string(from: completedAt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if let scheduledAt = todo.scheduledAt {
                        Text(formatter.string(from: scheduledAt))
                            .font(.caption)
                            .foregroundColor(todo.isOverdue() ? .red : .green)
                    }
                    if let description = todo.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(2)
        }
        .frame(height: 40)  // Ensures uniform height
    }
}

struct ActivityCard: View {
    
    var activity: Activity
    
    let now = Date()
    
    var isActive: Bool {
        return now >= activity.startDate && now <= activity.endDate
    }
    
    var isOver: Bool {
        return now > activity.endDate
    }

    var style: any ShapeStyle {
        if (isActive) { SelectionShapeStyle.selection }
        else if (isOver) { HierarchicalShapeStyle.tertiary }
        else { HierarchicalShapeStyle.secondary }
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("\(formatter.string(from: activity.startDate))")
                    .font(.caption)
                    .foregroundStyle(style)
                Text("\(formatter.string(from: activity.endDate))")
                    .font(.caption)
                    .foregroundStyle(style)
            }
            Text(activity.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)  // Ensures content alignment
        }
        .frame(height: 40)  // Ensures uniform height
    }
}

struct AnySchedulable: Identifiable {
    let id: UUID
    let content: Schedulable
    
    init(_ activity: Activity) {
        self.id = activity.id
        self.content = activity
    }
    
    init(_ todo: Todo) {
        self.id = todo.id
        self.content = todo
    }
}

#Preview {
    TodayView(
        todos: Todo.sampleData.filter { $0.isScheduledForToday() },
        activities: Activity.sampleActivities.filter { $0.isScheduledForToday() }
    )
}
