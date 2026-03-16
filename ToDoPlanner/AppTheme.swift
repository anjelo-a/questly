import SwiftUI

struct AppTheme: Equatable {
	var background: Color
	var surface: Color
	var surfaceAlt: Color
	var textPrimary: Color
	var textSecondary: Color
	var accent: Color
	var divider: Color
	var danger: Color
	var warning: Color

	var cornerRadiusLarge: CGFloat
	var cornerRadiusMedium: CGFloat
	var cornerRadiusSmall: CGFloat

	var spacingXS: CGFloat
	var spacingS: CGFloat
	var spacingM: CGFloat
	var spacingL: CGFloat
	var spacingXL: CGFloat

	var titleFont: Font
	var subtitleFont: Font
	var bodyFont: Font
	var captionFont: Font

	static let `default` = AppTheme(
		background: Color(red: 0xEE / 255, green: 0xF0 / 255, blue: 0xF8 / 255), // #EEF0F8
		surface: .white,
		surfaceAlt: Color(red: 0xFF / 255, green: 0xF5 / 255, blue: 0xE6 / 255), // #FFF5E6
		textPrimary: Color(red: 0x1A / 255, green: 0x1A / 255, blue: 0x2E / 255), // #1A1A2E
		textSecondary: Color(red: 0x8A / 255, green: 0x8F / 255, blue: 0xA8 / 255), // #8A8FA8
		accent: Color(red: 0x5B / 255, green: 0x7B / 255, blue: 0xFF / 255), // #5B7BFF
		divider: Color(red: 0xE0 / 255, green: 0xE4 / 255, blue: 0xF0 / 255), // #E0E4F0
			danger: Color(.systemRed),
		warning: Color(red: 0xF5 / 255, green: 0xA6 / 255, blue: 0x23 / 255), // #F5A623
		cornerRadiusLarge: 28,
		cornerRadiusMedium: 14,
		cornerRadiusSmall: 10,
		spacingXS: 4,
		spacingS: 8,
		spacingM: 12,
		spacingL: 16,
		spacingXL: 24,
		titleFont: .system(size: 32, weight: .bold),
		subtitleFont: .system(size: 18, weight: .semibold),
		bodyFont: .system(size: 16, weight: .regular),
		captionFont: .system(size: 14, weight: .regular)
	)
}

private struct AppThemeKey: EnvironmentKey {
	static let defaultValue: AppTheme = .default
}

extension EnvironmentValues {
	var appTheme: AppTheme {
		get { self[AppThemeKey.self] }
		set { self[AppThemeKey.self] = newValue }
	}
}

