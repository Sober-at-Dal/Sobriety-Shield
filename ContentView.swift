//
//  ContentView.swift
//  Sobreity Shield
//
//  Created by Emaan Grey on 2025-03-04.
//


import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var viewModel = SobrietyViewModel()
    @State private var showingRelapseConfirmation = false
    @State private var showingResetConfirmation = false
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // Extracted colors from logo
    private let primaryColor = Color(red: 0.8, green: 0.1, blue: 0.4) // Dark pink/magenta

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 5) {
                    Text("Sobriety Shield")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor) // Using logo color

                    Text("by Sober at Dal")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(primaryColor.opacity(0.8)) // Slightly lighter magenta
                }
                .padding(.top)

                // Current Streak Card
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.blue.opacity(0.1))
                        .allowsHitTesting(false) // Prevents blocking touches
                    
                    VStack {
                        Text("Current Streak")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(viewModel.sobrietyLog.currentStreakDays())")
                            .font(.system(size: 80, weight: .bold))
                        
                        Text("days")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    Button(action: {
                        selectedDate = viewModel.sobrietyLog.startDate
                        showingDatePicker = true
                    }) {
                        SobrietyStatCard(title: "Start Date", value: dateFormatter.string(from: viewModel.sobrietyLog.startDate))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    SobrietyStatCard(title: "Longest Streak", value: "\(viewModel.sobrietyLog.longestStreak()) days")
                    SobrietyStatCard(title: "Total Days", value: "\(viewModel.sobrietyLog.totalDaysSinceStart()) days")
                    SobrietyStatCard(title: "Relapses", value: "\(viewModel.sobrietyLog.relapses.count)")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        print("Log Relapse Button Pressed") // Debug Log
                        showingRelapseConfirmation = true
                    }) {
                        Text("Log Relapse")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        Text("Reset Tracker")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Export Data button
                    Button(action: {
                        print("Export Data Button Pressed")
                        viewModel.exportData()
                    }) {
                        Text("Export Data")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor.opacity(0.8)) // Logo color
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    // Attach the share sheet
                    .sheet(isPresented: $viewModel.showingShareSheet) {
                        if let exportedFileURL = viewModel.exportedFileURL {
                            ShareSheet(activityItems: [exportedFileURL])
                        }
                    }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            // ✅ Add missing alerts & sheet
            .alert("Log Relapse", isPresented: $showingRelapseConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Log", role: .destructive) {
                    print("Relapse Logged!") // Debugging Log
                    viewModel.logRelapse()
                }
            } message: {
                Text("Are you sure you want to log a relapse? Your streak will restart from today.")
            }
            .alert("Reset Tracker", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    print("Tracker Reset!") // Debugging Log
                    viewModel.resetTracker()
                }
            } message: {
                Text("This will reset all your sobriety data and start fresh from today. This action cannot be undone.")
            }
            .sheet(isPresented: $showingDatePicker) {
                VStack(spacing: 20) {
                    Text("Set Sobriety Start Date")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)

                    DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()

                    HStack {
                        Button("Cancel") {
                            showingDatePicker = false
                        }
                        .buttonStyle(BorderedButtonStyle())
                        .padding()

                        Spacer()

                        Button("Save") {
                            print("New Start Date: \(selectedDate)") // Debugging Log
                            viewModel.updateStartDate(selectedDate)
                            showingDatePicker = false
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding()
                    }
                }
                .padding()
            }
        }
    }

// SobrietyStatCard
struct SobrietyStatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.blue.opacity(0.1))
                .allowsHitTesting(false) // Prevents blocking touches
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding()
        }
        .frame(height: 100)
    }
}
