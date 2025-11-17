import Foundation

protocol NotesStore {
    func load() throws -> [Note]
    func save(_ notes: [Note]) throws
}
