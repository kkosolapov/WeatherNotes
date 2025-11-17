import SwiftUI

struct NotesListView: View {
    @StateObject var viewModel: NotesListViewModel

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    ContentUnavailableView("No notes yet",
                                           systemImage: "square.and.pencil",
                                           description: Text("Add your first note to capture the moment with weather."))
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            NavigationLink {
                                NoteDetailView(viewModel: NoteDetailViewModel(note: note))
                            } label: {
                                NoteRow(note: note, dateFormatter: dateFormatter)
                            }
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Weather Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isPresentingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add note")
                }
            }
            .sheet(isPresented: $viewModel.isPresentingAdd) {
                AddNoteView { text in
                    await viewModel.addNote(text: text)
                }
                .presentationDetents([.medium, .large])
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { _ in viewModel.alertMessage = nil }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
        }
    }
}

private struct NoteRow: View {
    let note: Note
    let dateFormatter: DateFormatter

    var body: some View {
        HStack(spacing: 12) {
            WeatherIconView(iconCode: note.weather.icon, size: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.headline)
                    .lineLimit(2)
                Text(dateFormatter.string(from: note.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(Int(round(note.weather.temperature)))°")
                .font(.title3).monospacedDigit()
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}
