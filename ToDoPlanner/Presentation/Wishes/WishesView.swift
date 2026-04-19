import SwiftUI

struct WishesView: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack {
			theme.background.ignoresSafeArea()

			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 16) {
					VStack(alignment: .leading, spacing: 4) {
						Text("Wishes")
							.font(theme.titleFont)
							.foregroundStyle(theme.textPrimary)

						Text("Spend your hard-earned points")
							.font(.system(size: 16, weight: .regular))
							.foregroundStyle(theme.textSecondary)
					}
					.padding(.top, 16)

					AvailablePointsCard()
						.padding(.top, 8)

					Text("Available Wishes")
						.font(.system(size: 20, weight: .bold))
						.foregroundStyle(theme.textPrimary)
						.padding(.top, 8)

					VStack(spacing: 12) {
						WishRow(
							border: theme.warning,
							iconBackground: theme.surfaceAlt,
							iconURL: URL(string: "https://www.figma.com/api/mcp/asset/8a19770f-2db5-451b-af6d-3572cd80c161")!,
							title: "Coffee Break",
							subtitle: "Treat yourself to a specialty coff...",
							cost: "50 pts",
							buttonColor: theme.warning
						)
						WishRow(
							border: theme.accent,
							iconBackground: Color(red: 0xEE / 255, green: 0xF2 / 255, blue: 0xFF / 255),
							iconURL: URL(string: "https://www.figma.com/api/mcp/asset/673d2718-ffba-4d2c-b87c-60924af9086c")!,
							title: "Movie Night",
							subtitle: "Watch your favorite film guilt-free",
							cost: "150 pts",
							buttonColor: theme.accent
						)
						WishRow(
							border: Color(red: 0x9B / 255, green: 0x7F / 255, blue: 0xE8 / 255),
							iconBackground: Color(red: 0xF3 / 255, green: 0xEF / 255, blue: 0xFF / 255),
							iconURL: URL(string: "https://www.figma.com/api/mcp/asset/21baf96f-c639-414a-8128-0cc10c818dda")!,
							title: "30min Gaming",
							subtitle: "Play your favorite game",
							cost: "100 pts",
							buttonColor: Color(red: 0x9B / 255, green: 0x7F / 255, blue: 0xE8 / 255)
						)
						WishRow(
							border: Color(red: 0xE8 / 255, green: 0x6B / 255, blue: 0x89 / 255),
							iconBackground: Color(red: 0xFF / 255, green: 0xE8 / 255, blue: 0xEE / 255),
							iconURL: URL(string: "https://www.figma.com/api/mcp/asset/c27a8a3a-6e9b-4b65-9e82-44f1b1ab7e0b")!,
							title: "Spa Day",
							subtitle: "A relaxing self-care session",
							cost: "500 pts",
							buttonColor: Color(red: 0xE8 / 255, green: 0x6B / 255, blue: 0x89 / 255)
						)
						WishRow(
							border: Color(red: 0x4C / 255, green: 0xAF / 255, blue: 0x82 / 255),
							iconBackground: Color(red: 0xE8 / 255, green: 0xF7 / 255, blue: 0xF0 / 255),
							iconURL: URL(string: "https://www.figma.com/api/mcp/asset/79561c97-1899-4145-8886-fdbcaf7cb313")!,
							title: "New Book",
							subtitle: "Buy a book you've been eyeing",
							cost: "250 pts",
							buttonColor: Color(red: 0x4C / 255, green: 0xAF / 255, blue: 0x82 / 255)
						)
						WishRow(
							border: theme.warning,
							iconBackground: theme.surfaceAlt,
							iconURL: URL(string: "https://www.figma.com/api/mcp/asset/aafe8f74-0110-4687-a79b-2ddfb154a849")!,
							title: "Custom Reward",
							subtitle: "Create your own reward",
							cost: "",
							buttonColor: theme.warning
						)
					}

					Spacer(minLength: 24)
				}
				.padding(.horizontal, 16)
				.padding(.bottom, 120)
			}
		}
		.navigationTitle("")
		.navigationBarTitleDisplayMode(.inline)
	}
}

private struct AvailablePointsCard: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack(alignment: .topLeading) {
			LinearGradient(
				colors: [
					theme.warning,
					Color(red: 0xE8 / 255, green: 0x95 / 255, blue: 0x10 / 255),
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

			VStack(alignment: .leading, spacing: 10) {
				Text("AVAILABLE POINTS")
					.font(.system(size: 12, weight: .semibold))
					.foregroundStyle(Color.white.opacity(0.8))
					.tracking(0.6)

				Text("1,874")
					.font(.system(size: 48, weight: .bold))
					.foregroundStyle(.white)

				Text("Ready to spend")
					.font(.system(size: 14, weight: .regular))
					.foregroundStyle(Color.white.opacity(0.8))
			}
			.padding(24)

			VStack {
				Spacer()
				HStack {
					Spacer()
					ZStack {
						Circle()
							.fill(Color.white.opacity(0.1))
						RemoteIcon(url: URL(string: "https://www.figma.com/api/mcp/asset/272439e1-9b6f-48e9-9020-caa08ec3327b")!)
							.frame(width: 40, height: 40)
					}
					.frame(width: 80, height: 80)
				}
			}
			.padding(24)
		}
		.frame(height: 156)
		.shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
	}
}

private struct WishRow: View {
	@Environment(\.appTheme) private var theme
	let border: Color
	let iconBackground: Color
	let iconURL: URL
	let title: String
	let subtitle: String
	let cost: String
	let buttonColor: Color

	var body: some View {
		HStack(spacing: 16) {
			ZStack {
				RoundedRectangle(cornerRadius: 14, style: .continuous)
					.fill(iconBackground)
				RemoteIcon(url: iconURL)
					.frame(width: 24, height: 24)
			}
			.frame(width: 48, height: 48)

			VStack(alignment: .leading, spacing: 4) {
				Text(title)
					.font(.system(size: 18, weight: .semibold))
					.foregroundStyle(theme.textPrimary)
					.lineLimit(1)
				Text(subtitle)
					.font(.system(size: 14, weight: .regular))
					.foregroundStyle(theme.textSecondary)
					.lineLimit(2)
				if !cost.isEmpty {
					Text("⚡ \(cost)")
						.font(.system(size: 14, weight: .medium))
						.foregroundStyle(theme.warning)
				}
			}

			Spacer(minLength: 12)

			Button {} label: {
				Text("Redeem")
					.font(.system(size: 16, weight: .semibold))
					.foregroundStyle(.white)
					.padding(.horizontal, 18)
					.padding(.vertical, 10)
					.background(buttonColor)
					.clipShape(Capsule())
			}
			.buttonStyle(.plain)
			.disabled(true)
			.opacity(0.6)
			.accessibilityLabel(Text("Redeem unavailable"))
			.accessibilityHint(Text("Rewards redemption is not available in this version"))
		}
		.padding(.leading, 16)
		.padding(.trailing, 12)
		.frame(minHeight: 104)
		.background(theme.surface)
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
		.overlay(
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.strokeBorder(border, lineWidth: 3)
				.padding(.leading, -1) // visually similar left accent
		)
		.shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 1)
	}
}
