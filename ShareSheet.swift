//
//  ShareSheet.swift
//  Sobriety Shield
//
//  Created by Emaan Grey on 2025-03-06.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
