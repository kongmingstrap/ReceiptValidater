//
//  ViewController.swift
//  ReceiptValidater
//
//  Created by tanaka.takaaki on 2017/09/15.
//  Copyright © 2017年 tanaka.takaaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func valid(sender: Any) {
        let receipt = "sample"
        let data = receipt.data(using: .utf8)!
        
        let base64encodedReceipt = data.base64EncodedString()
        
        let requestDictionary = ["receipt-data": receipt]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"  // this works but as noted above it's best to use your own trusted server
            let validationURL = URL(string: validationURLString)!
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                if let data = data , error == nil {
                    do {
                        let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
                        print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
                        // if you are using your server this will be a json representation of whatever your server provided
                    } catch let error as NSError {
                        print("json serialization failed with error: \(error)")
                    }
                } else {
                    print("the upload task returned an error: \(error)")
                }
            }
            task.resume()
        } catch let error as NSError {
            print("json serialization failed with error: \(error)")
        }
    }
}

