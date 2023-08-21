//
//  SafariView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/8/21.
//

import SwiftUI
import SafariServices
struct SafariView: UIViewControllerRepresentable {
    
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
}
