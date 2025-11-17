import Foundation
import Combine

@MainActor
final class AddNoteViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?

    private let onSave: (String) async -> Void

    init(onSave: @escaping (String) async -> Void) {
        self.onSave = onSave
    }

    func save() async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isSaving = true
        defer { isSaving = false }
        await onSave(trimmed)
    }
}
