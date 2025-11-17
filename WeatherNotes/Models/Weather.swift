import Foundation

struct Weather: Codable, Equatable {
    var temperature: Double
    var condition: WeatherCondition
    var description: String
    var icon: String
    var locationName: String
}

enum WeatherCondition: String, Codable {
    case clear
    case clouds
    case rain
    case drizzle
    case thunderstorm
    case snow
    case mist
    case smoke
    case haze
    case dust
    case fog
    case sand
    case ash
    case squall
    case tornado
    case unknown
}
