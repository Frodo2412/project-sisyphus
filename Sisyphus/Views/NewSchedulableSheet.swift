import SwiftUI

enum SchedulableType: Hashable {
    case todo
    case activity
}

struct NewSchedulableSheet: View {
    
    @State private var selected: SchedulableType = .todo
    
    var body: some View {
#if os(iOS)
        Picker(selection: $selected, label: Text("Select Type")) {
            Text("Todo").tag(SchedulableType.todo)
            Text("Activity").tag(SchedulableType.activity)
        }
        .pickerStyle(.segmented)
        .padding()
#endif
        
        TabView(selection: $selected) {
            Tab("Todo", systemImage: "checkmark.circle", value: .todo) {
                Text("Create Todo")
            }
            Tab("Activity", systemImage: "calendar", value: .activity) {
                Text("Create Activity")
            }
        }
#if os(iOS)
        .tabViewStyle(.page)
#endif
    }

}

#Preview {
    NewSchedulableSheet()
}
