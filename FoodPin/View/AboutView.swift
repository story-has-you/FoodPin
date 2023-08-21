//
//  AboutView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/8/21.
//

import SwiftUI

struct AboutView: View {
    
    @State private var link: WebLink?
    
    var body: some View {
        NavigationStack {
            List {
                Image("about")
                    .resizable()
                    .scaledToFit()
                
                Section {
                    // 使用内建safari浏览器
                    Link(destination: URL(string: WebLink.rateUs.rawValue)!) {
                        Label("Rate us on App Store", image: "store")
                            .foregroundColor(.primary)
                    }
                
                    Label("Tell us your feedback", image: "chat")
                        .onTapGesture {
                            link = .feedback
                        }
                }
                
                Section {
                   
                    Label("Twitter", image: "twitter")
                        .onTapGesture {
                            link = .twitter
                        }
                    Label("Facebook", image: "facebook")
                        .onTapGesture {
                            link = .facebook
                        }
                    Label("Instagram", image: "instagram")
                        .onTapGesture {
                            link = .instagram
                        }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.automatic)
            .sheet(item: $link) { item in
                if let url = URL(string: item.rawValue) {
                    SafariView(url: url)
                }
            }
        }
    }
    
    enum WebLink: String, Identifiable {
            case rateUs = "https://www.apple.com/ios/app-store"
            case feedback = "https://www.appcoda.com/contact"
            case twitter = "https://www.twitter.com/appcodamobile"
            case facebook = "https://www.facebook.com/appcodamobile"
            case instagram = "https://www.instagram.com/appcodadotcom"
            
            var id: UUID {
                UUID()
            }
        }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
