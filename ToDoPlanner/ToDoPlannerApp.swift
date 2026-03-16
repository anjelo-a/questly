import SwiftUI

@main
struct ToDoPlannerApp: App {
	@StateObject private var taskStore = TaskStore()
	@StateObject private var calendarClient = CalendarClient()

	var body: some Scene {
		WindowGroup {
			HomeView()
				.environmentObject(taskStore)
				.environmentObject(calendarClient)
				.environment(\.appTheme, .default)
		}
	}
}

