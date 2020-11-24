//
//  ViewController.swift
//  PushDemo
//

import UIKit
import PushSDK
import SwiftyBeaver
import UserNotifications


class ViewController: UIViewController {
    
    
    let pushAdapterSdk = PushSDK.init(platform_branch: PushSDKVar.branchMasterValue, log_level: PushSDKVar.LOGLEVEL_DEBUG, basePushURL: "https://test-push.hyber.im/api/")
    
    //for production
    //let pushAdapterSdk = PushSDK.init(basePushURL: "https://push.hyber.im/api/")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register in notification center
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
        UNUserNotificationCenter.current().delegate = self
    
    }
    
   
    //processing incoming data message
    @objc func onReceiveFromPushServer(_ notification: Notification) {
        // Do something now
        let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir
        print(incomMessage.message.toString())
        textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()
    }
    
    
    @IBOutlet weak var textOutput: UITextView!
    @IBOutlet weak var txt1fiIn: UITextField!
    

    //clear message display field
    @IBAction func button1Click(_ sender: UIButton) {
        textOutput.text = ""
    }
    
    //test button, register this device on push server
    @IBAction func button2register(_ sender: UIButton) {
        let tttt: PushKFunAnswerRegister = pushAdapterSdk.push_register_new(user_phone: txt1fiIn.text ?? "375291234567", user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")
        textOutput.text = "\(String(textOutput.text))\n\(tttt.toString())"
    }
    
    //test button, check message queue on server
    @IBAction func button3core(_ sender: UIButton) {
        let queue = pushAdapterSdk.push_check_queue()
        textOutput.text = "\(String(textOutput.text))\n\(queue.toString())"
    }
    
    //test button, unused
    @IBAction func button4savecore(_ sender: UIButton) {
        //test
    }
    
    //clear only local deviceid
    @IBAction func button5clearself(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.push_clear_current_device().toString())"
    }
    
    //get all devices from server registered for current msisdn
    @IBAction func button6getdevice(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.push_get_device_all_from_server().toString())"
    }
    
    //send test callback message to specific message
    @IBAction func button7callback(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.push_send_message_callback(message_id: "test", message_text: "privet").toString())"
    }
    
    
    //send delivery report for test with fake message id
    @IBAction func button8dr(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.push_message_delivery_report(message_id: "1251fqf4").toString())"
    }
    
    //token update on server test button
    @IBAction func button9update(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(pushAdapterSdk.push_update_registration().toString())"
    }
    
    //get message history test button
    @IBAction func button10gethistory(_ sender: UIButton) {
        let hist: PushKFunAnswerGetMessageHistory = pushAdapterSdk.push_get_message_history(period_in_seconds: 12345)
        textOutput.text = "\(String(textOutput.text))\n\(hist.toString())"
    }
    
    //clear all registered devices test button
    @IBAction func button11clearall(_ sender: Any) {
        let cle_p = pushAdapterSdk.push_clear_all_device()
        textOutput.text = "\(String(textOutput.text))\n\(cle_p.toString())"
    }
}


