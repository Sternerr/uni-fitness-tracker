//
//  APIService.swift
//  fitness-tracker
//
//  Created by Noah Sterner on 2025-02-13.
//

import SwiftData
import Foundation



struct Suggestions: Codable {
    let suggestions: [Suggestion]  // Notice the plural "suggestions" instead of "suggestion"
    
    struct Suggestion: Codable, Hashable {
        let value: String
    }
}

//Singleton Pattern
class APIService {
    static let shared = APIService()
    private let baseURL = URL(string: "https://wger.de/api/v2/exercise/search/?language=en&term=")!
    
    private init() {}
    
    func fetchExercises(withFilter filter: String) async -> Suggestions {
        guard !filter.isEmpty else { return Suggestions(suggestions: []) }
        
        let url = URL(string: "\(baseURL)\(filter)")
        let request = URLRequest(url: url!)
        
        if let (data, _) = try? await URLSession.shared.data(for: request) {
            return self.JSONfrom(data: data)
        }
        
        return Suggestions(suggestions: [])
    }
    
    private func JSONfrom(data: Data) -> Suggestions {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(Suggestions.self, from: data)
        } catch {
            fatalError("\(error)")
        }
    }
}

struct Goal: Identifiable, Hashable {
    let id: UUID = UUID()
    var title: String
    var description: String
}
