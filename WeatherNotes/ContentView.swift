import SwiftUI

struct ContentView: View {

    @AppStorage("appAppearance") private var appAppearance: Int = 0

    private var isDarkMode: Bool {
        appAppearance == 2
    }

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 12) {
                Toggle(isOn: Binding(
                    get: { isDarkMode },
                    set: { newValue in
                        appAppearance = newValue ? 2 : 1
                    }
                )) {
                    Text("Dark Mode")
                }
                .toggleStyle(.switch)

                Spacer()

                Button {
                    appAppearance = 0
                } label: {
                    Text("Use System")
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(.thinMaterial)

            // Main content
            NotesListView(
                viewModel: NotesListViewModel(
                    store: UserDefaultsNotesStore(),
                    weatherService: OpenWeatherService()
                )
            )
        }
    }
}

