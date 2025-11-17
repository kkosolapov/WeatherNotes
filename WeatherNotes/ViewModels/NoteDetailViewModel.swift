import Foundation
import Combine

@MainActor
final class NoteDetailViewModel: ObservableObject {
    @Published private(set) var note: Note

    init(note: Note) {
        self.note = note
    }
}
