import Foundation

struct CurrentWeatherDTO: Decodable {
    struct WeatherEntry: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Double
    }

    struct Sys: Decodable {
        let country: String?
    }

    let weather: [WeatherEntry]
    let main: Main
    let name: String
    let sys: Sys?

    func toDomain() -> Weather {
        let entry = weather.first
        let condition = WeatherCondition(fromAPI: entry?.main ?? "")
        return Weather(
            temperature: main.temp,
            condition: condition,
            description: entry?.description ?? "",
            icon: entry?.icon ?? "",
            locationName: name
        )
    }
}

extension WeatherCondition {
    init(fromAPI main: String) {
        switch main.lowercased() {
        case "clear": self = .clear
        case "clouds": self = .clouds
        case "rain": self = .rain
        case "drizzle": self = .drizzle
        case "thunderstorm": self = .thunderstorm
        case "snow": self = .snow
        case "mist": self = .mist
        case "smoke": self = .smoke
        case "haze": self = .haze
        case "dust": self = .dust
        case "fog": self = .fog
        case "sand": self = .sand
        case "ash": self = .ash
        case "squall": self = .squall
        case "tornado": self = .tornado
        default: self = .unknown
        }
    }
}
