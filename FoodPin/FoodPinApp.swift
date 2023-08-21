//
//  FoodPinApp.swift
//  FoodPin
//
//  Created by Simon Ng on 14/10/2022.
//

import SwiftUI
import UserNotifications

@main
struct FoodPinApp: App {
    
    let persistenceController =  PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle") ?? UIColor(red: 218, green: 96, blue: 51), .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle") ?? UIColor(red: 218, green: 96, blue: 51), .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
            navBarAppearance.backgroundColor = .clear
            navBarAppearance.backgroundEffect = .none
            navBarAppearance.shadowColor = .clear
            
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            UINavigationBar.appearance().compactAppearance = navBarAppearance
        }
}


final class MainSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    @Environment(\.openURL) private var openURL: OpenURLAction
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }
    
    private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        
        guard let shortcutIdentifier = shortcutType.components(separatedBy: ".").last else {
            return false
        }
        
        guard let url = URL(string: "foodpinapp://actions/" + shortcutIdentifier) else {
            print("Failed to initiate the url")
            return false
        }
        
        openURL(url)
        
        return true
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let shortcutItem = connectionOptions.shortcutItem else {
            return
        }

        handleQuickAction(shortcutItem: shortcutItem)
    }
}


final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Main Scene", sessionRole: connectingSceneSession.role)
        
        configuration.delegateClass = MainSceneDelegate.self
        
        return configuration
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            if granted {
                print("User notifications are allowed.")
            } else {
                print("User notifications are not allowed.")
            }
            
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "foodpin.makeReservation" {
            print("Make reservation...")
            if let phone = response.notification.request.content.userInfo["phone"] {
                let telURL = "tel://\(phone)"
                if let url = URL(string: telURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        print("calling \(telURL)")
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        
        completionHandler()
    }
}
