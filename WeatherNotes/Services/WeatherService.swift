import Foundation

protocol WeatherService {
    func currentWeatherForKyiv() async throws -> Weather
}
