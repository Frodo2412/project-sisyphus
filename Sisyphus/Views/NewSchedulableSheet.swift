import SwiftUI

enum SchedulableType: Hashable {
    case todo
    case activity
}

struct NewSchedulableSheet: View {
    
    @State private var selected: SchedulableType = .todo
    
    var body: some View {
#if os(iOS)
        Picker(selection: $selected, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
            Text("Todo").tag(SchedulableType.todo)
            Text("Activity").tag(SchedulableType.activity)
        }.pickerStyle(.palette)
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