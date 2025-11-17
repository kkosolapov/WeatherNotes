import SwiftUI


@main
struct WeatherNotesApp: App {
    @AppStorage("appAppearance") private var appAppearance: Int = 0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme)
        }
    }

    private var colorScheme: ColorScheme? {
        switch appAppearance {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}

