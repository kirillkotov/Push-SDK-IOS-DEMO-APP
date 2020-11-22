//
//  ViewController.swift
//  PushDemo
//

import UIKit
import PushSDK
import SwiftyBeaver
import UserNotifications

class ViewController: UIViewController {
    
    
    let push_adapter_sdk = PushSDK.init(platform_branch: PushSdkParametersPublic.branchMasterValue, log_level: SwiftyBeaver.Level.debug, basePushURL: "https://example.com/api/")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        UNUserNotificationCenter.current().delegate = self
    
    }
    
   
    //processing incoming data message
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        print("ncenter shshdfghf")
        print(notification.userInfo)
        let jsonData = try? JSONSerialization.data(withJSONObject: notification.userInfo, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let newString = String(jsonString).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        print(newString)
        textOutput.text = textOutput.text + "\n" + newString
    }
    
    @IBOutlet weak var textOutput: UITextView!
    @IBOutlet weak var txt1fiIn: UITextField!
    

    //clear message display field
    @IBAction func button1Click(_ sender: UIButton) {
        textOutput.text = ""
    }
    
    //test button, register this device on push server
    @IBAction func button2register(_ sender: UIButton) {
        let tttt: PushKFunAnswerRegister = push_adapter_sdk.push_register_new(user_phone: txt1fiIn.text ?? "375291234567", user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")
        textOutput.text = "\(String(textOutput.text))\n\(tttt.toString())"
    }
    
    //test button, check message queue on server
    @IBAction func button3core(_ sender: UIButton) {
        let queue = push_adapter_sdk.push_check_queue()
        textOutput.text = "\(String(textOutput.text))\n\(queue.toString())"
    }
    
    //test button, unused
    @IBAction func button4savecore(_ sender: UIButton) {
        //test
    }
    
    //clear only local deviceid
    @IBAction func button5clearself(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(push_adapter_sdk.push_clear_current_device().toString())"
    }
    
    //get all devices from server registered for current msisdn
    @IBAction func button6getdevice(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(push_adapter_sdk.push_get_device_all_from_server().toString())"
    }
    
    //send test callback message to specific message
    @IBAction func button7callback(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(push_adapter_sdk.push_send_message_callback(message_id: "test", message_text: "privet").toString())"
    }
    
    
    //send delivery report for test with fake message id
    @IBAction func button8dr(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(push_adapter_sdk.push_message_delivery_report(message_id: "1251fqf4").toString())"
    }
    
    //token update on server test button
    @IBAction func button9update(_ sender: UIButton) {
        textOutput.text = "\(String(textOutput.text))\n\(push_adapter_sdk.push_update_registration().toString())"
    }
    
    //get message history test button
    @IBAction func button10gethistory(_ sender: UIButton) {
        let hist: PushKFunAnswerGetMessageHistory = push_adapter_sdk.push_get_message_history(period_in_seconds: 12345)
        textOutput.text = "\(String(textOutput.text))\n\(hist.toString())"
    }
    
    //clear all registered devices test button
    @IBAction func button11clearall(_ sender: Any) {
        let cle_p = push_adapter_sdk.push_clear_all_device()
        textOutput.text = "\(String(textOutput.text))\n\(cle_p.toString())"
    }
}

