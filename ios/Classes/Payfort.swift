//  ViewController.swift
//  PayfortDemo
//
//  Created by Aman Aggarwal on 8/29/18.
//  Copyright © 2018 Clickapps. All rights reserved.
//
import UIKit
class ViewController: UIViewController {
var payFort: PayFortController!
    fileprivate let accessCode = "NSCHvL3NNId94GojFhvP"
    fileprivate let merchantIdentifier = "WwpBYMkd"
    fileprivate let requestPhrase = "Hello"
override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        payFort = PayFortController(enviroment:KPayFortEnviromentSandBox)
        createMobileSDkToken()
    }
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createMobileSDkToken() {
        //Add the Merchant's Passphrase(showed here as REQUESTPHRASE) at the beginning and end of the parameters string
        var post = ""//Helloaccess_code=NSCHvL3NNId94GojFhvPdevice_id=ffffffff-a46f-329c-6398-60210033c587language=enmerchant_identifier=WwpBYMkdservice_command=SDK_TOKENHello"
        post = post.appending("\(requestPhrase)access_code=\(accessCode)")
        post = post.appending("device_id=\(payFort.getUDID()!)")
        post = post.appending("language=\("en")")
        post = post.appending("merchant_identifier=\(merchantIdentifier)")
        post = post.appending("service_command=SDK_TOKEN\(requestPhrase)")
        var paramDict:Dictionary<String, AnyObject> = Dictionary()
                paramDict.updateValue("SDK_TOKEN" as AnyObject, forKey: "service_command")
                paramDict.updateValue(accessCode as AnyObject, forKey: "access_code")
                paramDict.updateValue("en" as AnyObject, forKey: "language")
                paramDict.updateValue(merchantIdentifier as AnyObject, forKey: "merchant_identifier")
                paramDict.updateValue(payFort.getUDID()! as AnyObject, forKey: "device_id")
                paramDict.updateValue(post.sha256() as AnyObject, forKey: "signature")
        do {
                    let postData = try JSONSerialization.data(withJSONObject: paramDict, options: .prettyPrinted)
                    let tokenAPIEndpoint = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi"
                    guard let url = URL(string: tokenAPIEndpoint) else {
                        print("invalid url")
                        return
                    }
                    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
                    request.httpBody = postData
                    let length = postData.count
                    request.httpMethod = "POST"
                    request.addValue("\(length)", forHTTPHeaderField: "Content-Length")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("we have encountered an error == \(error.localizedDescription)")
                        }
                        guard let data = data else {
                            return
                        }
        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                            print("json == \(json)")
                            if let dict = json as? Dictionary<String, AnyObject> {
                                if let status = dict["status"] as? String {
                                    if status == "22" {
                                        //succesfully get token start payment
                                        if let SDKToken = dict["sdk_token"] as? String {
                                            DispatchQueue.main.async {
                                            self.startOnlineTransactionWith(token: SDKToken)
                                            }
                                        }
                                }
                                                        } else {
                                                            print("token creation failed")
                                                        }
                                }
                                                } catch let error {
                                                    print("We have error decoding == \(error.localizedDescription)")
                                                }
                                }.resume()operation holds an amount from the Customer’s credit card account for a period of time until the Merchant capture or voids the transaction.
                                } catch let error {
                                            print("error creating json from paramDict, == \(error.localizedDescription)")
                                        }
    }
    func startOnlineTransactionWith(token:String) {
        let request = NSMutableDictionary.init()
        request.setValue("100000", forKey: "amount")
        request.setValue("PURCHASE", forKey: "command")
        request.setValue("AED", forKey: "currency")
        request.setValue("test@clickapps.co", forKey: "customer_email")
        request.setValue("en", forKey: "language")
        request.setValue("orderIDTest2", forKey: "merchant_reference")//should be unique
        request.setValue(token , forKey: "sdk_token")
        payFort.callPayFort(withRequest: request , currentViewController: self,
                            success: { (requestDic, responeDic) in
                                print("success")
                                },
                            canceled: { (requestDic, responeDic) in
                                print("canceled")
                             },
                            faild: { (requestDic, responeDic, message) in
                                print("failed")
                                print("requestDic=\(requestDic)")
                                print("responeDic=\(responeDic)")
                                print("message=\(message)")
                                })
    }
}


extension String {
    func sha256() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}