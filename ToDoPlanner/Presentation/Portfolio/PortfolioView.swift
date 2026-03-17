import SwiftUI

struct PortfolioView: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack {
			theme.background.ignoresSafeArea()

			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 16) {
					VStack(alignment: .leading, spacing: 4) {
						Text("Portfolio")
							.font(theme.titleFont)
							.foregroundStyle(theme.textPrimary)

						Text("Your productivity assets")
							.font(.system(size: 16, weight: .regular))
							.foregroundStyle(theme.textSecondary)
					}
					.padding(.top, 16)

					// Top gradient card (simplified but matches layout intent)
					PortfolioTopCard()

					Text("Points Growth")
						.font(.system(size: 20, weight: .bold))
						.foregroundStyle(theme.textPrimary)

					PortfolioChartCard()

					PortfolioStatsGrid()

					Text("Recent Activity")
						.font(.system(size: 20, weight: .bold))
						.foregroundStyle(theme.textPrimary)

					VStack(spacing: 10) {
						ForEach(0..<7, id: \.self) { idx in
							RecentActivityRow(points: [28, 46, 85, 80, 32, 20, 91][idx])
						}
					}

					Spacer(minLength: 24)
				}
				.padding(.horizontal, 16)
				.padding(.bottom, 120)
			}
		}
	}
}

private struct PortfolioTopCard: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack(alignment: .topLeading) {
			LinearGradient(
				colors: [
					Color(red: 0x5B / 255, green: 0x7B / 255, blue: 0xFF / 255),
					Color(red: 0x4A / 255, green: 0x6A / 255, blue: 0xEE / 255),
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

			VStack(alignment: .leading, spacing: 10) {
				HStack {
					Text("TOTAL BALANCE")
						.font(.system(size: 12, weight: .semibold))
						.foregroundStyle(Color.white.opacity(0.8))
						.tracking(0.6)
					Spacer()
					Text("● LIVE")
						.font(.system(size: 12, weight: .semibold))
						.foregroundStyle(Color.green)
				}

				Text("1,874")
					.font(.system(size: 40, weight: .bold))
					.foregroundStyle(.white)

				Text("points")
					.font(.system(size: 14, weight: .regular))
					.foregroundStyle(Color.white.opacity(0.7))

				Text("↗︎ +28 today")
					.font(.system(size: 12, weight: .regular))
					.foregroundStyle(Color.white.opacity(0.8))
			}
			.padding(20)
		}
		.frame(height: 140)
		.shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
	}
}

private struct PortfolioChartCard: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack {
				Text("Points Growth")
					.font(.system(size: 14, weight: .semibold))
					.foregroundStyle(theme.textPrimary)
				Spacer()
				HStack(spacing: 10) {
					Text("1W").foregroundStyle(.white)
						.padding(.horizontal, 10)
						.padding(.vertical, 6)
						.background(theme.accent)
						.clipShape(Capsule())
					Text("1M").foregroundStyle(theme.textSecondary)
					Text("ALL").foregroundStyle(theme.textSecondary)
				}
				.font(.system(size: 12, weight: .medium))
			}

			RoundedRectangle(cornerRadius: 12, style: .continuous)
				.fill(Color(red: 0xD7 / 255, green: 0xE2 / 255, blue: 0xFF / 255).opacity(0.6))
				.overlay(
					RoundedRectangle(cornerRadius: 12, style: .continuous)
						.stroke(theme.divider, lineWidth: 1)
				)
				.frame(height: 160)
		}
		.padding(16)
		.background(theme.surface)
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
		.shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 1)
	}
}

private struct PortfolioStatsGrid: View {
	@Environment(\.appTheme) private var theme

	private let columns = [
		GridItem(.flexible(), spacing: 12),
		GridItem(.flexible(), spacing: 12),
	]

	var body: some View {
		LazyVGrid(columns: columns, spacing: 12) {
			SmallStatCard(icon: "🏆", value: "1,845", label: "All-time high")
			SmallStatCard(icon: "✅", value: "0", label: "Tasks Completed")
			SmallStatCard(icon: "📅", value: "31", label: "Active Days")
			SmallStatCard(icon: "⚡", value: "0", label: "Avg per Task")
		}
	}

	private func SmallStatCard(icon: String, value: String, label: String) -> some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(icon)
				.font(.system(size: 16))
			Text(value)
				.font(.system(size: 20, weight: .bold))
				.foregroundStyle(theme.textPrimary)
			Text(label)
				.font(.system(size: 12, weight: .regular))
				.foregroundStyle(theme.textSecondary)
		}
		.padding(16)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(theme.surface)
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
		.shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
	}
}

private struct RecentActivityRow: View {
	@Environment(\.appTheme) private var theme
	let points: Int

	var body: some View {
		HStack(spacing: 12) {
			ZStack {
				RoundedRectangle(cornerRadius: 10, style: .continuous)
					.fill(theme.surfaceAlt)
				Text("⚡")
					.font(.system(size: 14))
			}
			.frame(width: 32, height: 32)

			VStack(alignment: .leading, spacing: 2) {
				Text("Daily tasks completed")
					.font(.system(size: 14, weight: .semibold))
					.foregroundStyle(theme.textPrimary)
				Text("2026-03-16")
					.font(.system(size: 12, weight: .regular))
					.foregroundStyle(theme.textSecondary)
			}

			Spacer()

			Text("+\(points)")
				.font(.system(size: 14, weight: .semibold))
				.foregroundStyle(theme.warning)
		}
		.padding(14)
		.background(theme.surface)
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
		.overlay(
			RoundedRectangle(cornerRadius: 14, style: .continuous)
				.stroke(theme.divider, lineWidth: 1)
		)
	}
}

