//
//  StatCard.swift
//  Sobreity Shield
//
//  Created by Emaan Grey on 2025-03-04.
//


import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.blue.opacity(0.05))
            
            VStack(spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding()
        }
    }
}
