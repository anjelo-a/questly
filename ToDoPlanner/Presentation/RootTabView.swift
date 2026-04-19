import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
	case planner
	case focus
	case habits
	case portfolio
	case more

	var id: String { rawValue }
}

struct RootTabView: View {
	@Environment(\.appTheme) private var theme
	@State private var selection: AppTab = .planner

	private let homeViewModel: HomeViewModel

	init(homeViewModel: HomeViewModel) {
		self.homeViewModel = homeViewModel
	}

	var body: some View {
		ZStack(alignment: .bottom) {
			currentTabContent
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.zIndex(0)

			bottomNav
				.zIndex(10)
		}
		.background(theme.background.ignoresSafeArea())
	}

	@ViewBuilder
	private var currentTabContent: some View {
		switch selection {
		case .planner:
			NavigationStack {
				HomeView(viewModel: homeViewModel)
			}
		case .focus:
			NavigationStack { FocusView() }
		case .habits:
			NavigationStack { HabitsView() }
		case .portfolio:
			NavigationStack { PortfolioView() }
		case .more:
			NavigationStack {
				MoreView(
					homeViewModel: homeViewModel,
					onOpenInboxComposer: {
						withAnimation(.easeOut(duration: 0.18)) {
							selection = .planner
						}
						homeViewModel.presentNewTask(for: .inbox)
					}
				)
			}
		}
	}

	private var bottomNav: some View {
		HStack(spacing: 0) {
			tabButton(.planner)
			Spacer()
			tabButton(.focus, showLabelWhenSelected: false)
			Spacer()
			tabButton(.habits, showLabelWhenSelected: false)
			Spacer()
			tabButton(.portfolio, showLabelWhenSelected: false)
			Spacer()
			tabButton(.more, showLabelWhenSelected: false)
		}
		.padding(.horizontal, 16)
		.padding(.top, 12)
		.frame(height: 80)
		.frame(maxWidth: .infinity)
		.background(theme.surface)
		.clipShape(Capsule())
		.shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 10)
		.padding(.horizontal, 16)
		.padding(.bottom, 10)
	}

	private func tabButton(_ tab: AppTab, showLabelWhenSelected: Bool = true) -> some View {
		let isSelected = selection == tab
		return Button {
			withAnimation(.easeOut(duration: 0.18)) {
				selection = tab
			}
		} label: {
			VStack(spacing: 4) {
				Image(systemName: symbolName(for: tab))
					.font(.system(size: 20, weight: .semibold))

				if isSelected, showLabelWhenSelected {
					Text(tab.title)
						.font(.system(size: 12, weight: .medium))
						.lineLimit(1)
						.minimumScaleFactor(0.9)
				}
			}
			.foregroundStyle(isSelected ? .white : theme.textSecondary)
			.frame(width: isSelected && showLabelWhenSelected ? 68 : 44, height: 56)
			.background(isSelected ? theme.accent : Color.clear)
			.clipShape(Capsule())
		}
		.buttonStyle(.plain)
		.accessibilityLabel(Text(tab.title))
		.accessibilityAddTraits(isSelected ? .isSelected : [])
	}

	private func symbolName(for tab: AppTab) -> String {
		switch tab {
		case .planner:
			"calendar"
		case .focus:
			"clock"
		case .habits:
			"checkmark.circle"
		case .portfolio:
			"chart.line.uptrend.xyaxis"
		case .more:
			"ellipsis"
		}
	}
}

private extension AppTab {
	var title: String {
		switch self {
		case .planner: "Planner"
		case .focus: "Focus"
		case .habits: "Habits"
		case .portfolio: "Portfolio"
		case .more: "More"
		}
	}
}
