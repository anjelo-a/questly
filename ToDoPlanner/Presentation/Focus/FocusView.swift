import SwiftUI

struct FocusView: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack {
			Color(red: 0x0D / 255, green: 0x0F / 255, blue: 0x1A / 255)
				.ignoresSafeArea()

			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 16) {
					VStack(alignment: .leading, spacing: 4) {
						Text("Focus")
							.font(theme.titleFont)
							.foregroundStyle(.white)

						Text("Deep work mode")
							.font(.system(size: 16, weight: .regular))
							.foregroundStyle(Color(red: 0x99 / 255, green: 0xA1 / 255, blue: 0xAF / 255))
					}
					.padding(.top, 16)

					HStack(spacing: 12) {
						FocusPresetPill(title: "25 / 5", subtitle: "min", isSelected: true)
						FocusPresetPill(title: "50 / 10", subtitle: "min", isSelected: false)
						FocusPresetPill(title: "90 / 15", subtitle: "min", isSelected: false)
					}

					ZStack {
						RemoteIcon(url: URL(string: "https://www.figma.com/api/mcp/asset/22138c13-284f-4bb9-a138-5db1b3c22aaa")!)
							.frame(width: 320, height: 320)
							.rotationEffect(.degrees(-90))

						VStack(spacing: 8) {
							Text("25:00")
								.font(.system(size: 60, weight: .bold))
								.foregroundStyle(.white)

							Text("100%")
								.font(.system(size: 18, weight: .regular))
								.foregroundStyle(Color(red: 0x6A / 255, green: 0x72 / 255, blue: 0x82 / 255))
						}
						.frame(width: 320, height: 320)
					}
					.frame(maxWidth: .infinity)

					Button {} label: {
						HStack(spacing: 10) {
							RemoteIcon(url: URL(string: "https://www.figma.com/api/mcp/asset/5edcd227-419a-4818-b84c-797d6932fffe")!)
								.frame(width: 20, height: 20)
							Text("Start Focus")
								.font(.system(size: 18, weight: .semibold))
								.lineLimit(1)
								.minimumScaleFactor(0.9)
						}
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.frame(height: 68)
						.background(theme.accent)
						.clipShape(Capsule())
					}
					.buttonStyle(.plain)
					.accessibilityHint(Text("Starts a focus timer"))

					VStack(alignment: .leading, spacing: 16) {
						Text("FOCUS TIPS")
							.font(.system(size: 12, weight: .semibold))
							.foregroundStyle(Color(red: 0x6A / 255, green: 0x72 / 255, blue: 0x82 / 255))
							.tracking(0.6)

						VStack(alignment: .leading, spacing: 12) {
							Text("• Put your phone face-down")
							Text("• Close unnecessary browser tabs")
							Text("• Drink water before starting")
						}
						.font(.system(size: 16, weight: .regular))
						.foregroundStyle(Color(red: 0xD1 / 255, green: 0xD5 / 255, blue: 0xDC / 255))
					}
					.padding(24)
					.frame(maxWidth: .infinity, alignment: .leading)
					.background(Color(red: 0x1A / 255, green: 0x1D / 255, blue: 0x2E / 255))
					.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

					Spacer(minLength: 24)
				}
				.padding(.horizontal, 16)
				.padding(.bottom, 120)
			}
		}
	}
}

private struct FocusPresetPill: View {
	let title: String
	let subtitle: String
	let isSelected: Bool

	var body: some View {
		VStack(spacing: 2) {
			Text(title)
				.font(.system(size: 18, weight: .bold))
				.lineLimit(1)
				.minimumScaleFactor(0.8)
			Text(subtitle)
				.font(.system(size: 12, weight: .medium))
		}
		.foregroundStyle(isSelected ? .white : Color(red: 0x99 / 255, green: 0xA1 / 255, blue: 0xAF / 255))
		.frame(width: 106, height: 78)
		.background(isSelected ? Color(red: 0x5B / 255, green: 0x7B / 255, blue: 0xFF / 255) : Color(red: 0x1A / 255, green: 0x1D / 255, blue: 0x2E / 255))
		.clipShape(Capsule())
		.accessibilityElement(children: .combine)
		.accessibilityAddTraits(isSelected ? .isSelected : [])
	}
}

