//
//  ViewController.swift
//  PushDemo
//

// final rel

import UIKit
import PushSDK
import UserNotifications
import MaterialComponents


class ViewController: UIViewController {
    
    /**
     PushSDK instance
     */
    let pushAdapterSdk = PushSDK.init(platform_branch: PushSDKVar.branchMasterValue, log_level: PushSDKVar.LOGLEVEL_DEBUG, basePushURL: "https://test.com/api/")
    
    //for production
    //let pushAdapterSdk = PushSDK.init(basePushURL: "https://example.com/api/")
    
    @IBOutlet var textOutput: UITextView!
    @IBOutlet var txt1fiIn: MDCOutlinedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textOutput.layer.borderColor = UIColor.gray.cgColor
        textOutput.layer.borderWidth = 2
        textOutput.layer.cornerRadius = 5
        txt1fiIn.label.text = "Phone number"
        
        //register in notification center
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
        UNUserNotificationCenter.current().delegate = self
    
    }
    
    /**
     Set the output text
     */
    func setOutputText(text: String) {
        if (!text.isEmpty) {
            textOutput.text = text
        }
        else {
            textOutput.text = "Empty yet"
        }
    }
    
    /**
     Clear the output text
     */
    @IBAction func clearOutput(_ sender: UIButton) {
        setOutputText(text: "")
    }
    
    /**
     Register device on the server
     */
    @IBAction func registerDevice(_ sender: UIButton) {
        let result: PushKFunAnswerRegister = pushAdapterSdk.pushRegisterNew(user_phone: txt1fiIn.text ?? "375291234567", user_password: "1", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")
        setOutputText(text: result.toString())
    }
    
    /**
     Check message queue
     */
    @IBAction func checkQueue(_ sender: UIButton) {
        let result = pushAdapterSdk.pushCheckQueue()
        setOutputText(text: result.toString())
    }
    
    /**
     Unused
     */
    @IBAction func button4savecore(_ sender: UIButton) {
        //test
    }
    
    /**
     Unregister current device
     */
    @IBAction func unregisterCurrentDevice(_ sender: UIButton) {
        let result = pushAdapterSdk.pushClearCurrentDevice()
        setOutputText(text: result.toString())
    }
    
    /**
     Get all registered devices
     */
    @IBAction func getAllDevices(_ sender: UIButton) {
        let result = pushAdapterSdk.pushGetDeviceAllFromServer()
        setOutputText(text: result.toString())
    }
    
    /**
     Send test message
     */
    @IBAction func sendTestMessage(_ sender: UIButton) {
        let result = pushAdapterSdk.pushSendMessageCallback(message_id: "test", message_text: "privet")
        setOutputText(text: result.toString())
    }
    
    
    /**
     Get message delivery report
     */
    @IBAction func getMessageDeliveryReport(_ sender: UIButton) {
        let result = pushAdapterSdk.pushMessageDeliveryReport(message_id: "1251fqf4")
        setOutputText(text: result.toString())
    }
    
    /**
     Update device registration
     */
    @IBAction func updateRegistration(_ sender: UIButton) {
        let result = pushAdapterSdk.pushUpdateRegistration()
        setOutputText(text: result.toString())
    }
    
    /**
     Get message history
     */
    @IBAction func getMessageHistory(_ sender: UIButton) {
        let result: PushKFunAnswerGetMessageHistory = pushAdapterSdk.pushGetMessageHistory(period_in_seconds: 12345)
        setOutputText(text: result.toString())
    }
    
    /**
     Unregister all devices
     */
    @IBAction func unregisterAllDevices(_ sender: Any) {
        let result = pushAdapterSdk.pushClearAllDevice()
        setOutputText(text: result.toString())
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


extension ViewController: UNUserNotificationCenterDelegate {
    
    /**
     For displaying notification when app is in foreground
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        print("#############Notification center###############")
        print(notification.request.content.body)
        print(notification.request.content.title)
        print(notification.request.content.subtitle)
        print(notification.request.content.userInfo)
        let incomMessage = PushSDK.parseIncomingPush(message: notification.request.content.userInfo)
        print(incomMessage)
        print(incomMessage.messageFir.message.messageId ?? "")
        print(incomMessage.messageFir.message.phone ?? "")
        print(incomMessage.messageFir.message.image?.url ?? "")
        print("###############################################")
        completionHandler([.alert, .badge, .sound])
    }
    
    /**
     For handling tap and user actions
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    /**
     Processing incoming data message
     */
    @objc func onReceiveFromPushServer(_ notification: Notification) {
        // Do something now
        let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir
        print(incomMessage.message.toString())
        print(incomMessage.message.title ?? "")
        print(incomMessage.message.messageId ?? "")
        textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate{
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
