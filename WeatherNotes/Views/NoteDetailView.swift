import SwiftUI

struct NoteDetailView: View {
    @StateObject var viewModel: NoteDetailViewModel

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Text(viewModel.note.text)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                Text(dateFormatter.string(from: viewModel.note.createdAt))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                WeatherIconView(iconCode: viewModel.note.weather.icon, size: 100)
                    .padding(.top, 8)

                Text("\(Int(round(viewModel.note.weather.temperature)))°C")
                    .font(.system(size: 48, weight: .bold, design: .rounded))

                Text(viewModel.note.weather.description.capitalized)
                    .font(.headline)

                if !viewModel.note.weather.locationName.isEmpty {
                    Label(viewModel.note.weather.locationName, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }

                Spacer(minLength: 24)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
