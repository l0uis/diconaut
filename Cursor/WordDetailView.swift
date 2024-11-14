//
//  WordDetailView.swift
//  Cursor
//
//  Created by Louis Currie on 07.11.24.
//

import SwiftUI

struct WordDetailView: View {
    let word: Word
    @ObservedObject var dbService: DatabaseService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(word.original)
                    .font(.title)
                Text(word.translation)
                    .font(.title2)
                Text(word.language)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Translation")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dbService.toggleBookmark(word)
                    } label: {
                        Image(systemName: dbService.isWordBookmarked(word) ? "bookmark.fill" : "bookmark")
                    }
                }
            }
            .tint(Color(hex: "FF4B4B"))
        }
    }
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WordDetailView(word: Word.sampleWords[0], dbService: DatabaseService())
    }
}
