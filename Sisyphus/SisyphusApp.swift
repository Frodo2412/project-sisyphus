import SwiftUI

@main
struct SisyphusApp: App {
    
    var body: some Scene {
        WindowGroup {
            TodayView(TodayViewModel.sample)
        }
    }
}
