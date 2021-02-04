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
    

    let pushAdapterSdk = PushSDK.init(platform_branch: PushSDKVar.branchMasterValue, log_level: PushSDKVar.LOGLEVEL_DEBUG, basePushURL: "https://test.com/api/")
    
    //for production
    //let pushAdapterSdk = PushSDK.init(basePushURL: "https://example.com/api/")
    

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
    
    @IBOutlet weak var textOutput: UITextView!
    @IBOutlet weak var txt1fiIn: MDCOutlinedTextField!
    
    //clear message display field
    @IBAction func button1Click(_ sender: UIButton) {
        textOutput.text = ""
    }
    
    //test button, register this device on push server
    @IBAction func button2register(_ sender: UIButton) {
        let tttt: PushKFunAnswerRegister = pushAdapterSdk.pushRegisterNew(user_phone: txt1fiIn.text ?? "375291234567", user_password: "1", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")
        textOutput.text = "\(String(textOutput.text))\n\(tttt.toString())"
    }
    
    //test button, check message queue on server
    @IBAction func button3core(_ sender: UIButton) {
        let queue = pushAdapterSdk.pushCheckQueue()
        textOutput.text = "\(String(textOutput.text))\n\(queue.toString())"
    }
    
    //test button, unused
    @IBAction func button4savecore(_ sender: UIButton) {
        //test
    }
    
    //clear only local deviceid
    @IBAction func button5clearself(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.pushClearCurrentDevice().toString())"
    }
    
    //get all devices from server registered for current msisdn
    @IBAction func button6getdevice(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.pushGetDeviceAllFromServer().toString())"
    }
    
    //send test callback message to specific message
    @IBAction func button7callback(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.pushSendMessageCallback(message_id: "test", message_text: "privet").toString())"
    }
    
    
    //send delivery report for test with fake message id
    @IBAction func button8dr(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.pushMessageDeliveryReport(message_id: "1251fqf4").toString())"
    }
    
    //token update on server test button
    @IBAction func button9update(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.pushUpdateRegistration().toString())"
    }
    
    //get message history test button
    @IBAction func button10gethistory(_ sender: UIButton) {
        let hist: PushKFunAnswerGetMessageHistory = pushAdapterSdk.pushGetMessageHistory(period_in_seconds: 12345)
        textOutput.text = "\(String(textOutput.text))\n\(hist.toString())"
    }
    
    //clear all registered devices test button
    @IBAction func button11clearall(_ sender: Any) {
        let cle_p = pushAdapterSdk.pushClearAllDevice()
        textOutput.text = "\(String(textOutput.text))\n\(cle_p.toString())"
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
    
    //for displaying notification when app is in foreground
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
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    //processing incoming data message
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
