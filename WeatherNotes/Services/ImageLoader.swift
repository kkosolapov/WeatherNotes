import SwiftUI

struct WeatherIconView: View {
    let iconCode: String
    let size: CGFloat

    init(iconCode: String, size: CGFloat = 32) {
        self.iconCode = iconCode
        self.size = size
    }

    var body: some View {
        
        AsyncImage(url: iconURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            case .failure:
                Image(systemName: "cloud.sun.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundStyle(.secondary)
            @unknown default:
                EmptyView()
            }
        }
        .accessibilityLabel("Weather icon")
    }

    private var iconURL: URL? {
        let iconString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        return URL(string: iconString)
    }
}
