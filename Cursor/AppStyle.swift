//
//  AppStyle.swift
//  Cursor
//
//  Created by Louis Currie on 07.11.24.
//

import SwiftUI

enum AppStyle {
    // MARK: - Colors
    enum Colors {
        static let accent = Color(hex: "FF4B4B")    // Primary accent color (red)
        static let placeholder = Color(hex: "4A4A4A") // Placeholder text color
        static let inputText = Color.black           // Input text color
        static let background = Color.black          // App background
        static let searchBackground = Color.white    // Search input background
    }
    
    // MARK: - Font Sizes
    enum FontSizes {
        static let searchInput = 16.0        // Search field text
        static let searchResults = 24.0      // Search results and recent searches text
        static let navigationTitle = 17.0    // Navigation bar title
        static let sectionHeader = 18.0      // Section headers (e.g., "Recent Searches")
        static let listItem = 18.0          // List items
    }
    
    // MARK: - Dimensions
    enum Dimensions {
        static let searchHeight = 48.0       // Search input height
        static let cornerRadius = 6.0        // Search input corner radius
        static let horizontalPadding = 12.0  // Standard horizontal padding
        static let verticalPadding = 8.0     // Standard vertical padding
    }
    
    // MARK: - Font Styles
    enum Fonts {
        static let searchInput = Font.system(size: FontSizes.searchInput)
        static let searchResults = Font.system(size: FontSizes.searchResults, weight: .regular)
        static let navigationTitle = Font.system(size: FontSizes.navigationTitle, weight: .semibold)
        static let sectionHeader = Font.system(size: FontSizes.sectionHeader, weight: .semibold)
        static let listItem = Font.system(size: FontSizes.listItem, weight: .regular)
    }
}
