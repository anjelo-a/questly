import SwiftUI

@main
struct ToDoPlannerApp: App {
	@StateObject private var homeViewModel = HomeViewModel()

	var body: some Scene {
		WindowGroup {
			RootTabView(homeViewModel: homeViewModel)
				.environment(\.appTheme, .default)
		}
	}
}
