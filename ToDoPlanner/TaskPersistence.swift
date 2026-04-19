import Foundation

struct TaskPersistence {
	private let fileManager: FileManager
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder
	private let storageURL: URL

	init(fileManager: FileManager = .default) {
		self.fileManager = fileManager

		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		encoder.dateEncodingStrategy = .iso8601
		self.encoder = encoder

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		self.decoder = decoder

		let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
			?? fileManager.temporaryDirectory
		self.storageURL = appSupportURL
			.appendingPathComponent("Questly", isDirectory: true)
			.appendingPathComponent("tasks.json", isDirectory: false)
	}

	func loadTasks() -> [TodoItem] {
		guard fileManager.fileExists(atPath: storageURL.path) else { return [] }

		do {
			let data = try Data(contentsOf: storageURL)
			return try decoder.decode([TodoItem].self, from: data)
		} catch {
			// If the file is unreadable or the schema changes later, start from empty state.
			return []
		}
	}

	func saveTasks(_ tasks: [TodoItem]) {
		let directoryURL = storageURL.deletingLastPathComponent()

		do {
			try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
			let data = try encoder.encode(tasks)
			try data.write(to: storageURL, options: [.atomic])
		} catch {
			// Persistence failure should not break the in-memory planner experience.
		}
	}
}
