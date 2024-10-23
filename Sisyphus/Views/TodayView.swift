import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel: TodayViewModel
    
    @State private var isPresentingNewForm: Bool = false
    
    // Initialize the view with the ViewModel
    init(_ viewModel: TodayViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Agenda")) {
                    ForEach(viewModel.scheduledItems, id: \.start) { schedulable in
                        if let activity = schedulable as? Activity {
                            ActivityCard(activity: .constant(activity))
                        } else if let todo = schedulable as? Todo {
                            TodoCard(todo: .constant(todo))
                        }
                    }
                }
                Section(header: Text("Sometime today")) {
                    ForEach(viewModel.unscheduledTodos, id: \.id) { todo in
                        TodoCard(todo: .constant(todo))
                    }
                }
            }
            .navigationTitle("Today")
            .toolbar {
                Button(action: {
                    isPresentingNewForm = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Todo")
            }
        }
    }
}

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"  // e.g., "2:30 PM"
    return formatter
}()

struct TodoCard: View {
    @Binding var todo: Todo
    
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
        .frame(height: 40)
    }
}

struct ActivityCard: View {
    @Binding var activity: Activity
    
    let now = Date()
    
    var isActive: Bool {
        now >= activity.startDate && now <= activity.endDate
    }
    
    var isOver: Bool {
        now > activity.endDate
    }
    
    var style: any ShapeStyle {
        if isActive {
            return SelectionShapeStyle.selection
        } else if isOver {
            return HierarchicalShapeStyle.tertiary
        } else {
            return HierarchicalShapeStyle.secondary
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(formatter.string(from: activity.startDate))
                    .font(.caption)
                    .foregroundStyle(style)
                Text(formatter.string(from: activity.endDate))
                    .font(.caption)
                    .foregroundStyle(style)
            }
            Text(activity.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 40)
    }
}

#Preview {
    TodayView(TodayViewModel.sample)
}
