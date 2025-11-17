//
//  Note.swift
//  WeatherNotes
//
//  Created by Kostia on 15.11.2025.
//

import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var createdAt: Date
    var weather: Weather

    init(id: UUID = UUID(), text: String, createdAt: Date = Date(), weather: Weather) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.weather = weather
    }
}
