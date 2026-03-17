import SwiftUI

struct RemoteIcon: View {
	let url: URL

	var body: some View {
		AsyncImage(url: url) { phase in
			switch phase {
			case .empty:
				Color.clear
			case .success(let image):
				image
					.resizable()
					.scaledToFit()
			case .failure:
				Color.clear
			@unknown default:
				Color.clear
			}
		}
	}
}

