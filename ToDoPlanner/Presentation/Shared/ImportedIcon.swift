import SwiftUI
import UIKit

struct ImportedIcon: View {
	let name: String

	var body: some View {
		if let uiImage = loadImage() {
			Image(uiImage: uiImage)
				.renderingMode(.template)
				.resizable()
				.scaledToFit()
		} else {
			Color.clear
		}
	}

	private func loadImage() -> UIImage? {
		let candidates: [URL?] = [
			Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "Resources/Icons"),
			Bundle.main.url(forResource: name, withExtension: "png"),
		]

		for url in candidates.compactMap({ $0 }) {
			if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
				return image
			}
		}

		return nil
	}
}

