import Foundation

final class UserDefaultsNotesStore: NotesStore {
    private let key = "weather_notes_storage_v1"
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func load() throws -> [Note] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return try decoder.decode([Note].self, from: data)
    }

    func save(_ notes: [Note]) throws {
        let data = try encoder.encode(notes)
        defaults.set(data, forKey: key)
    }
}
