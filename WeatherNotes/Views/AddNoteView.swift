import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddNoteViewModel

    init(onSave: @escaping (String) async -> Void) {
        _viewModel = StateObject(wrappedValue: AddNoteViewModel(onSave: onSave))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("What happened?", text: $viewModel.text, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
                    .padding(.horizontal)

                Spacer()

                HStack(spacing: 16) {
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(action: save) {
                        if viewModel.isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isSaving || viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("New Note")
        }
    }

    private func save() {
        Task {
            await viewModel.save()
            dismiss()
        }
    }
}
