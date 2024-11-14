//
//  SavedWordsView.swift
//  Cursor
//
//  Created by Louis Currie on 07.11.24.
//

import SwiftUI

struct SavedWordsView: View {
    @ObservedObject var dbService: DatabaseService
    @State private var selectedWord: Word?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            if dbService.bookmarkedWords.isEmpty {
                Text("No saved words yet")
                    .foregroundColor(.secondary)
            } else {
                ForEach(dbService.bookmarkedWords) { word in
                    WordRow(word: word)
                        .onTapGesture {
                            selectedWord = word
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                dbService.toggleBookmark(word)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("Saved Words")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "FF4B4B"))
                        Text("Back")
                            .foregroundColor(Color(hex: "FF4B4B"))
                    }
                }
            }
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word, dbService: dbService)
        }
        .tint(Color(hex: "FF4B4B"))
    }
}

struct SavedWordsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SavedWordsView(dbService: DatabaseService())
        }
        .tint(Color(hex: "FF4B4B"))
    }
}
