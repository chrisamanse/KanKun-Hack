//
//  ViewController.swift
//  KanKun Hack
//
//  Created by Joe Amanse on 18/01/2016.
//  Copyright © 2016 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var currentIPAddressTextField: UITextField!
    
    let session = NSURLSession.sharedSession()
    
    var currentIPAddress: String {
        return currentIPAddressTextField.text ?? ""
    }
    
    func currentURLWithParameter(parameter: String) -> NSURL {
        let urlString = "http://\(currentIPAddress)/cgi-bin/relay.cgi?\(parameter)"
        
        print(urlString)
        return NSURL(string: urlString) ?? NSURL()
    }
    
    func currentRequestWithParameter(parameter: String) -> NSURLRequest {
        return NSURLRequest(URL: currentURLWithParameter(parameter), cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadState()
    }
    
    func didReceiveStateText(text: String?) {
        let finalText = text ?? ""
        print("Loading state: \(finalText)")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.currentStatusLabel.text = finalText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadState() {
        fetchStateWithCompletionHandler(didReceiveStateText)
    }
    
    func fetchStateWithCompletionHandler(completion: (textReceived: String?) -> Void) {
        let task = session.dataTaskWithRequest(currentRequestWithParameter("state")) { (data, response, error) -> Void in
            guard error == nil, let fetchedData = data else {
                print("Error \(error!)")
                return
            }
            
            print("Successfully checked state: \(response)")
            
            let string = NSString(data: fetchedData, encoding: NSUTF8StringEncoding) as? String
            completion(textReceived: string)
        }
        task.resume()
    }
    
    @IBAction func didPressOn(sender: AnyObject) {
        let task = session.dataTaskWithRequest(currentRequestWithParameter("on")) { (data, response, error) -> Void in
            guard error == nil else {
                print("Error \(error!)")
                return
            }
            
            print("Successfully turned on: \(response)")
            self.loadState()
        }
        task.resume()
    }
    
    @IBAction func didPressOff(sender: AnyObject) {
        let task = session.dataTaskWithRequest(currentRequestWithParameter("off")) { (data, response, error) -> Void in
            guard error == nil else {
                print("Error \(error!)")
                return
            }
            
            print("Successfully turned off: \(response)")
            self.loadState()
        }
        task.resume()
    }
    
    @IBAction func didPressToggle(sender: AnyObject) {
        let task = session.dataTaskWithRequest(currentRequestWithParameter("toggle")) { (data, response, error) -> Void in
            guard error == nil else {
                print("Error \(error!)")
                return
            }
            
            print("Successfully toggled: \(response)")
            self.loadState()
        }
        task.resume()
    }
}

