import Foundation

enum WeatherServiceError: Error, LocalizedError {
    case missingAPIKey
    case badURL
    case badStatus(Int)
    case decoding
    case network(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "OpenWeather API key is missing."
        case .badURL: return "Failed to build request URL."
        case .badStatus(let code): return "Server returned HTTP \(code)."
        case .decoding: return "Failed to decode weather response."
        case .network(let underlying): return "Network error: \(underlying.localizedDescription)"
        }
    }
}

final class OpenWeatherService: WeatherService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func currentWeatherForKyiv() async throws -> Weather {
        let apiKey = try Self.apiKey()
        
        let OpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/weather?q=Kyiv,ua&appid=\(apiKey)"
        guard var comps = URLComponents(string: OpenWeatherMapURL) else {
            throw WeatherServiceError.badURL
        }
        comps.queryItems = [
            .init(name: "q", value: Constants.city),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: Constants.units),
            .init(name: "lang", value: Constants.lang)
        ]
        guard let url = comps.url else { throw WeatherServiceError.badURL }

        var request = URLRequest(url: url)
        request.timeoutInterval = 60

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw WeatherServiceError.badStatus(-1)
            }
            guard (200..<300).contains(http.statusCode) else {
                throw WeatherServiceError.badStatus(http.statusCode)
            }
            let dto = try JSONDecoder().decode(CurrentWeatherDTO.self, from: data)
            return dto.toDomain()
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw WeatherServiceError.decoding
        } catch {
            throw WeatherServiceError.network(underlying: error)
        }
    }

    private static func apiKey() throws -> String {

        if let key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String, !key.isEmpty {
            return key
        }
        throw WeatherServiceError.missingAPIKey
    }
}
