//
//  SobrietyViewModel.swift
//  Sobreity Shield
//
//  Created by Emaan Grey on 2025-03-04.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

class SobrietyViewModel: ObservableObject {
    @Published var sobrietyLog = SobrietyLog()
    @Published var exportedFileURL: URL? // Stores exported file URL
    @Published var showingShareSheet = false // Controls share sheet display

    private let fileName = "sobriety_data.json"
    
    init() {
        // Try to load saved data
        if let loadedLog = loadData() {
            self.sobrietyLog = loadedLog
        }
    }
    
    func logRelapse() {
        sobrietyLog.relapses.append(Date())
        saveData() // Save data after change
    }
    
    func resetTracker() {
        sobrietyLog = SobrietyLog()
        saveData() // Save data after reset
    }
    
    func updateStartDate(_ date: Date) {
        sobrietyLog.startDate = date
        saveData() // Save data after updating start date
    }
    
    func exportData() {
        let sobrietyText = """
        Sobriety Data:
        ---------------------
        Current Streak: \(sobrietyLog.currentStreakDays()) days
        Longest Streak: \(sobrietyLog.longestStreak()) days
        Total Days: \(sobrietyLog.totalDaysSinceStart()) days
        Relapses: \(sobrietyLog.relapses.count)
        """

        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("sobriety_data.txt")

        do {
            try sobrietyText.write(to: fileURL, atomically: true, encoding: .utf8)
            
            DispatchQueue.main.async {
                self.exportedFileURL = fileURL
                self.showingShareSheet = true // Trigger share sheet
            }

            print("Sobriety data exported to: \(fileURL)")
        } catch {
            print("Error exporting text data: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadData() -> SobrietyLog? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(SobrietyLog.self, from: data)
        } catch {
            print("Error loading data: \(error)")
            return nil
        }
    }
    
    private func saveData() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(sobrietyLog)
            try data.write(to: fileURL)
        } catch {
            print("Error saving data: \(error)")
        }
    }
}
