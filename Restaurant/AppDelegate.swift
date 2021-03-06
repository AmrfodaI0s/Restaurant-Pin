//
//  AppDelegate.swift
//  Restaurant
//
//  Created by hosam on 9/8/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import CoreData
import MOLH
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , MOLHResetable, UNUserNotificationCenterDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        checkIntroPassed()
        
    UINavigationBar.appearance().barTintColor = UIColor.init(r: 216, g: 74, b: 32)  
        UINavigationBar.appearance().tintColor = UIColor.white
        
        MOLH.shared.activate(true)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (gran, err) in
            if gran {
                print("user notification are allowed")
            }else {
                print("user notification not are allowed")
            }
        }
        return true
    }

    // MARK: - User Notifications
    
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
    
    func reset() {
        checkIntroPassed() 
//        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
//        let stry = UIStoryboard(name: "Main", bundle: nil)
//        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "rootnav")
    }
    
    func checkIntroPassed()  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let isPassed:Bool = UserDefaults.standard.object(forKey: "passIntro") as? Bool ?? false
        
        let tabs = MainTabBarVC()
        window?.rootViewController = isPassed ? tabs : WelcomePageVC(collectionViewLayout: layout)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "RestaurantsCored")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

