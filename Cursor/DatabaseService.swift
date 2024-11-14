//
//  DatabaseService.swift
//  Cursor
//
//  Created by Louis Currie on 07.11.24.
//

import Foundation

class DatabaseService: ObservableObject {
    @Published var recentWords: [Word] = []
    @Published var bookmarkedWords: [Word] = []
    @Published var isLoading = false
    
    func searchWord(_ query: String) async throws -> [Word] {
        guard !query.isEmpty else { return [] }
        guard query.count >= 2 else { return [] }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(encodedQuery)") else {
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return []
            }
            
            if httpResponse.statusCode == 404 {
                return []
            }
            
            guard httpResponse.statusCode == 200 else {
                return []
            }
            
            let entries = try JSONDecoder().decode([DictionaryEntry].self, from: data)
            
            // Convert API response to Word models and remove duplicates
            var uniqueWords: [Word] = []
            var seenWords: Set<String> = []
            
            for entry in entries {
                for meaning in entry.meanings {
                    if let definition = meaning.definitions.first?.definition,
                       !seenWords.contains(entry.word.lowercased()) {
                        seenWords.insert(entry.word.lowercased())
                        uniqueWords.append(Word(
                            original: entry.word,
                            translation: definition,
                            language: "English"
                        ))
                    }
                }
            }
            
            return uniqueWords
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            return []
        }
    }
    
    func addToRecent(_ word: Word) {
        // Remove if word already exists in recent searches
        recentWords.removeAll { $0.original.lowercased() == word.original.lowercased() }
        
        // Add to the beginning of the list
        recentWords.insert(word, at: 0)
        
        // Keep only the last 10 recent searches
        if recentWords.count > 10 {
            recentWords.removeLast()
        }
    }
    
    func toggleBookmark(_ word: Word) {
        if let index = bookmarkedWords.firstIndex(where: { $0.id == word.id }) {
            bookmarkedWords.remove(at: index)
        } else {
            var bookmarkedWord = word
            bookmarkedWord.isBookmarked = true
            bookmarkedWords.append(bookmarkedWord)
        }
    }
    
    func isWordBookmarked(_ word: Word) -> Bool {
        bookmarkedWords.contains(where: { $0.id == word.id })
    }
}

// API Response models
struct DictionaryEntry: Codable {
    let word: String
    let meanings: [Meaning]
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    let definition: String
}
