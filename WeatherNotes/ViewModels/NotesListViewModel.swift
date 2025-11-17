import Foundation
import Combine

@MainActor
final class NotesListViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    @Published var alertMessage: String?
    @Published var isPresentingAdd: Bool = false

    private let store: NotesStore
    private let weatherService: WeatherService

    init(store: NotesStore, weatherService: WeatherService) {
        self.store = store
        self.weatherService = weatherService
        loadNotes()
    }

    func loadNotes() {
        do {
            notes = try store.load().sorted(by: { $0.createdAt > $1.createdAt })
        } catch {
            alertMessage = "Failed to load notes: \(error.localizedDescription)"
        }
    }

    func addNote(text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        do {
            let weather = try await weatherService.currentWeatherForKyiv()
            var newNotes = notes
            let note = Note(text: text, createdAt: Date(), weather: weather)
            newNotes.insert(note, at: 0)
            try store.save(newNotes)
            notes = newNotes
        } catch {
            alertMessage = "Failed to add note: \(error.localizedDescription)"
        }
    }

    func delete(at offsets: IndexSet) {
        var newNotes = notes
        
        for index in offsets.sorted(by: >) {
            newNotes.remove(at: index)
        }
        do {
            try store.save(newNotes)
            notes = newNotes
        } catch {
            alertMessage = "Failed to delete note: \(error.localizedDescription)"
        }
    }
}
