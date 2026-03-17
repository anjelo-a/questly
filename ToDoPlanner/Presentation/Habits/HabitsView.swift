import SwiftUI

struct HabitsView: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack {
			theme.background.ignoresSafeArea()

			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 16) {
					VStack(alignment: .leading, spacing: 4) {
						Text("Habits")
							.font(theme.titleFont)
							.foregroundStyle(theme.textPrimary)

						Text("Build consistency every day")
							.font(.system(size: 16, weight: .regular))
							.foregroundStyle(theme.textSecondary)
					}
					.padding(.top, 16)

					HStack(spacing: 12) {
						StatsCard(background: Color(red: 0xEF / 255, green: 0xF6 / 255, blue: 0xFF / 255), iconURL: URL(string: "https://www.figma.com/api/mcp/asset/3438860b-d5bd-46a2-af3e-3c16551e8286")!, value: "3/3", caption: "Done today")
						StatsCard(background: Color(red: 0xFF / 255, green: 0xF7 / 255, blue: 0xED / 255), iconURL: URL(string: "https://www.figma.com/api/mcp/asset/3b132469-5104-4abc-9245-bc927e719fc1")!, value: "21", caption: "Best streak")
						StatsCard(background: Color(red: 0xF0 / 255, green: 0xFD / 255, blue: 0xF4 / 255), iconURL: URL(string: "https://www.figma.com/api/mcp/asset/dfcf79d8-ffe2-4aec-8d02-f11fb90b7039")!, value: "3", caption: "Habits")
					}

					Text("Today's Habits")
						.font(.system(size: 20, weight: .bold))
						.foregroundStyle(theme.textPrimary)
						.padding(.top, 8)

					VStack(spacing: 12) {
						HabitRow(accent: Color(red: 0x9B / 255, green: 0x7F / 255, blue: 0xE8 / 255), title: "Morning Meditation", subtitle: "5 min mindfulness", streak: "⚡ 4 day streak", points: "+20 pts", actionIconURL: URL(string: "https://www.figma.com/api/mcp/asset/706b383e-c76d-4d5b-a2f7-0ff17a609abe")!)
						HabitRow(accent: Color(red: 0x4C / 255, green: 0xAF / 255, blue: 0x82 / 255), title: "Exercise", subtitle: "30 min workout", streak: "⚡ 6 day streak", points: "+30 pts", actionIconURL: URL(string: "https://www.figma.com/api/mcp/asset/d5db4ce9-36f2-42b2-ab18-df5165a13e07")!)
						HabitRow(accent: theme.accent, title: "Read", subtitle: "20 pages minimum", streak: "⚡ 2 day streak", points: "+15 pts", actionIconURL: URL(string: "https://www.figma.com/api/mcp/asset/2c6d9d36-92a5-43d6-af6b-ca41430b57f9")!)
					}

					Text("Streak Overview")
						.font(.system(size: 20, weight: .bold))
						.foregroundStyle(theme.textPrimary)
						.padding(.top, 16)

					VStack(spacing: 12) {
						StreakRow(accent: Color(red: 0x9B / 255, green: 0x7F / 255, blue: 0xE8 / 255), title: "Morning Meditation", days: "4d")
						StreakRow(accent: Color(red: 0x4C / 255, green: 0xAF / 255, blue: 0x82 / 255), title: "Exercise", days: "6d")
						StreakRow(accent: theme.accent, title: "Read", days: "2d")
					}

					Spacer(minLength: 24)
				}
				.padding(.horizontal, 16)
				.padding(.bottom, 120)
			}
		}
	}
}

private struct StatsCard: View {
	@Environment(\.appTheme) private var theme
	let background: Color
	let iconURL: URL
	let value: String
	let caption: String

	var body: some View {
		VStack(spacing: 8) {
			RemoteIcon(url: iconURL)
				.frame(width: 24, height: 24)
			Text(value)
				.font(.system(size: 24, weight: .bold))
				.foregroundStyle(theme.textPrimary)
			Text(caption)
				.font(.system(size: 12, weight: .regular))
				.foregroundStyle(theme.textSecondary)
		}
		.frame(maxWidth: .infinity)
		.frame(height: 116)
		.background(background)
		.clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusMedium, style: .continuous))
	}
}

private struct HabitRow: View {
	@Environment(\.appTheme) private var theme
	let accent: Color
	let title: String
	let subtitle: String
	let streak: String
	let points: String
	let actionIconURL: URL

	var body: some View {
		HStack(spacing: 16) {
			Circle()
				.fill(accent)
				.frame(width: 12, height: 12)

			VStack(alignment: .leading, spacing: 4) {
				Text(title)
					.font(.system(size: 18, weight: .semibold))
					.foregroundStyle(theme.textPrimary)
					.lineLimit(1)
				Text(subtitle)
					.font(.system(size: 14, weight: .regular))
					.foregroundStyle(theme.textSecondary)
					.lineLimit(1)
				HStack(spacing: 8) {
					Text(streak)
						.font(.system(size: 12, weight: .regular))
						.foregroundStyle(theme.warning)
					Text(points)
						.font(.system(size: 12, weight: .regular))
						.foregroundStyle(theme.textSecondary)
				}
			}

			Spacer(minLength: 12)

			ZStack {
				Circle()
					.fill(accent.opacity(0.13))
				RemoteIcon(url: actionIconURL)
					.frame(width: 24, height: 24)
			}
			.frame(width: 40, height: 40)
		}
		.padding(.horizontal, 16)
		.frame(height: 107)
		.background(theme.surface)
		.clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusMedium, style: .continuous))
		.shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 1)
	}

 
}

private struct StreakRow: View {
	@Environment(\.appTheme) private var theme
	let accent: Color
	let title: String
	let days: String

	var body: some View {
		HStack(spacing: 12) {
			Circle()
				.fill(accent)
				.frame(width: 12, height: 12)
			Text(title)
				.font(.system(size: 14, weight: .regular))
				.foregroundStyle(theme.textPrimary)
			Spacer()
			HStack(spacing: 6) {
				ForEach(0..<7, id: \.self) { idx in
					RoundedRectangle(cornerRadius: 4, style: .continuous)
						.fill(idx < 4 ? accent.opacity(0.25) : Color(red: 0xE5 / 255, green: 0xE7 / 255, blue: 0xEB / 255))
						.frame(width: 10, height: 24)
				}
			}
			Text(days)
				.font(.system(size: 14, weight: .semibold))
				.foregroundStyle(theme.textSecondary)
				.frame(width: 32, alignment: .trailing)
		}
	}
}

