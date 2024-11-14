//
//  Word.swift
//  Cursor
//
//  Created by Louis Currie on 07.11.24.
//

import Foundation

struct Word: Identifiable, Hashable {
    let id = UUID()
    let original: String
    let translation: String
    let language: String
    var isBookmarked: Bool = false
    
    static let sampleWords = [
        Word(original: "Hello", translation: "Hola", language: "Spanish"),
        Word(original: "World", translation: "Mundo", language: "Spanish"),
        Word(original: "Good morning", translation: "Buenos días", language: "Spanish"),
        Word(original: "Thank you", translation: "Gracias", language: "Spanish"),
        Word(original: "Please", translation: "Por favor", language: "Spanish"),
        Word(original: "Goodbye", translation: "Adiós", language: "Spanish"),
        Word(original: "Friend", translation: "Amigo", language: "Spanish"),
        Word(original: "Water", translation: "Agua", language: "Spanish"),
        Word(original: "Food", translation: "Comida", language: "Spanish"),
        Word(original: "Time", translation: "Tiempo", language: "Spanish")
    ]
}
