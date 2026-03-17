import Foundation

protocol GetWeekDatesUseCase {
	func execute(selectedDate: Date) -> [Date]
}

struct DefaultGetWeekDatesUseCase: GetWeekDatesUseCase {
	func execute(selectedDate: Date) -> [Date] {
		let calendar = Calendar.current
		let start = calendar.date(
			from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
		) ?? selectedDate

		return (0..<7).compactMap { offset in
			calendar.date(byAdding: .day, value: offset, to: start)
		}
	}
}

