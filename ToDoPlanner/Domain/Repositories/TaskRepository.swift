import Foundation

protocol TaskRepository {
	func tasks(for date: Date, dayPart: DayPart) -> [TodoItem]
	func addTask(_ draft: NewTaskDraft, for date: Date)
	func toggleDone(_ id: UUID)
	func seedIfNeeded(for date: Date)
}

