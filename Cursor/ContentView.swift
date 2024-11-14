//
//  ContentView.swift
//  Cursor
//
//  Created by Louis Currie on 07.11.24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

struct ContentView: View {
    @StateObject private var dbService = DatabaseService()
    @State private var searchText = ""
    @State private var searchResults: [Word] = []
    @State private var selectedWord: Word?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search field with clear button
                HStack {
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty {
                            Text("Search for a word")
                                .foregroundColor(AppStyle.Colors.placeholder)
                                .padding(.horizontal, AppStyle.Dimensions.horizontalPadding)
                        }
                        
                        TextField("", text: $searchText)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, AppStyle.Dimensions.horizontalPadding)
                            .foregroundColor(AppStyle.Colors.inputText)
                            .tint(AppStyle.Colors.accent)
                            .font(AppStyle.Fonts.searchInput)
                    }
                    .frame(height: AppStyle.Dimensions.searchHeight)
                    .background(AppStyle.Colors.searchBackground)
                    .cornerRadius(AppStyle.Dimensions.cornerRadius)
                    .overlay(
                        HStack {
                            Spacer()
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    searchResults = []
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, AppStyle.Dimensions.horizontalPadding)
                                }
                            }
                        }
                    )
                    .onChange(of: searchText) { newValue in
                        searchResults = []
                        if !newValue.isEmpty && newValue.count >= 2 {
                            Task {
                                searchResults = try await dbService.searchWord(newValue) ?? []
                            }
                        }
                    }
                }
                .padding()
                
                // Content area
                if dbService.isLoading {
                    Spacer()
                    ProgressView("Searching...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else {
                    List {
                        if !searchText.isEmpty {
                            if searchText.count < 2 {
                                Text("Type at least 2 characters to search")
                                    .foregroundColor(.secondary)
                            } else if searchResults.isEmpty {
                                Text("No results found")
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(searchResults) { word in
                                    Text(word.original)
                                        .font(AppStyle.Fonts.searchResults)
                                        .padding(.vertical, AppStyle.Dimensions.verticalPadding)
                                        .onTapGesture {
                                            selectedWord = word
                                            dbService.addToRecent(word)
                                        }
                                }
                            }
                        } else {
                            // Recent searches header
                            Text("Recent Searches")
                                .font(AppStyle.Fonts.sectionHeader)
                                .foregroundColor(.secondary)
                                .padding(.vertical, AppStyle.Dimensions.verticalPadding)
                            
                            // Recent searches list
                            ForEach(dbService.recentWords) { word in
                                Text(word.original)
                                    .font(AppStyle.Fonts.searchResults)
                                    .padding(.vertical, 4)
                                    .onTapGesture {
                                        selectedWord = word
                                    }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(AppStyle.Colors.background)
                }
            }
            .navigationTitle("Dictionary")
            .toolbar {
                NavigationLink {
                    SavedWordsView(dbService: dbService)
                } label: {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(AppStyle.Colors.accent)
                }
            }
            .sheet(item: $selectedWord) { word in
                WordDetailView(word: word, dbService: dbService)
            }
            
            // Initial detail view for split view
            SavedWordsView(dbService: dbService)
        }
        .tint(AppStyle.Colors.accent)
    }
}

struct WordRow: View {
    let word: Word
    var showTranslation: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(word.original)
                .font(.headline)
            if showTranslation {
                Text(word.translation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
