import SwiftUI

struct InboxView: View {
	@Environment(\.appTheme) private var theme

	var body: some View {
		ZStack {
			theme.background.ignoresSafeArea()

			VStack(alignment: .leading, spacing: 0) {
				VStack(alignment: .leading, spacing: 4) {
					Text("Inbox")
						.font(theme.titleFont)
						.foregroundStyle(theme.textPrimary)
					Text("Capture & organize later")
						.font(.system(size: 16, weight: .regular))
						.foregroundStyle(theme.textSecondary)
				}
				.padding(.horizontal, 16)
				.padding(.top, 16)

				Spacer()

				VStack(spacing: 16) {
					ZStack {
						Circle()
							.fill(Color(red: 0xF3 / 255, green: 0xF4 / 255, blue: 0xF6 / 255))
						RemoteIcon(url: URL(string: "https://www.figma.com/api/mcp/asset/44c04413-8372-4467-8352-beae43dc0c95")!)
							.frame(width: 64, height: 64)
					}
					.frame(width: 128, height: 128)

					Text("Inbox is clear!")
						.font(.system(size: 24, weight: .bold))
						.foregroundStyle(theme.textPrimary)

					Text("Quick capture ideas and tasks here. Organize them into your planner later.")
						.font(.system(size: 16, weight: .regular))
						.foregroundStyle(theme.textSecondary)
						.multilineTextAlignment(.center)
						.padding(.horizontal, 28)

					Button {} label: {
						HStack(spacing: 10) {
							RemoteIcon(url: URL(string: "https://www.figma.com/api/mcp/asset/b6b2d89d-96a3-4f13-8327-ac0c6de3baf8")!)
								.frame(width: 20, height: 20)
							Text("Add to Inbox")
								.font(.system(size: 16, weight: .semibold))
								.lineLimit(1)
								.minimumScaleFactor(0.9)
						}
						.foregroundStyle(.white)
						.padding(.horizontal, 24)
						.frame(height: 48)
						.background(theme.accent)
						.clipShape(Capsule())
					}
					.buttonStyle(.plain)
				}

				Spacer()
			}
			.padding(.bottom, 120)
		}
		.navigationTitle("")
		.navigationBarTitleDisplayMode(.inline)
	}
}

