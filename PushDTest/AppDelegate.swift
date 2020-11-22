//
//  AppDelegate.swift
//  PushDemo
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import PushSDK



@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    let processor = PushKProcessing.init()
    let fb_ad = PushKFirebaseSdk.init()
    public var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    @IBOutlet weak var sentNotificationLabel: UILabel!
    
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        fb_ad.fb_fun0_application(didFinishLaunchingWithOptions: launchOptions)
        application.registerForRemoteNotifications()
        fb_ad.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
       
        return true
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        fb_ad.fb_fun1_application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        fb_ad.fb_fun2_application(didReceiveRemoteNotification: userInfo)
    }
    
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        fb_ad.fb_fun3_application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        fb_ad.fb_fun4_application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}


public extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate{
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler([.alert, .sound, .badge])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}


extension AppDelegate: MessagingDelegate {
    
    @IBAction func notify() {
        fb_ad.fb_notify_messaging()
    }
    
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        fb_ad.fb_remote_messaging(remoteMessage: remoteMessage.appData as NSDictionary)
    }
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        fb_ad.fb_token_messaging(didReceiveRegistrationToken: fcmToken )
    }
}


extension ViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
}
