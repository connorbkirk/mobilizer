//
//  ViewController3.swift
//  mobilizer
//
//  Created by Connor on 6/13/16.
//  Copyright © 2016 Connor Kirk. All rights reserved.
//

import UIKit
import NextGrowingTextView

class ViewController3: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var values: NSArray = []
    var id = String()
    var url = "http://mobilizer.x10.mx/get.php?id="
    var timer: NSTimer!
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel! //this is the session ID. used generic name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = id
        url+=id
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController3.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController3.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.growingTextView.layer.cornerRadius = 4
        //self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.growingTextView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        self.growingTextView.placeholderAttributedText = NSAttributedString(string: "Enter text...",
                                                                            attributes: [NSFontAttributeName: self.growingTextView.font!,
                                                                                NSForegroundColorAttributeName: UIColor.grayColor()
            ]
        )

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController3.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        scrollTableDown()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(get), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollTableDown(){
        if tableView.numberOfRowsInSection(0) > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
        }
    }

    func get(){
        let values_old: NSArray = values
        //values_old = values
        
        let nsURL = NSURL(string: url)
        let data = NSData(contentsOfURL: nsURL!)
        values = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        if(values != values_old){
            tableView.reloadData()
            scrollTableDown()
        }
    }
    
    func send(){
        let request = NSMutableURLRequest(URL: NSURL(string: "http://mobilizer.x10.mx/send.php")!)
        request.HTTPMethod = "POST"
        let postString = "id=\(id)&txt=\(growingTextView.text!)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SpecialCell
        let maindata = values[indexPath.row]
        cell.time.text = maindata["TIME"] as? String
        cell.message.text = maindata["MESSAGE"] as? String
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        timer.invalidate()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let _ = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                //key point 0,
                self.inputContainerViewBottom.constant =  0
                //textViewBottomConstraint.constant = keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                self.inputContainerViewBottom.constant = keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
        scrollTableDown()
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func handleSendButton(sender: UIButton) {
        send()
        growingTextView.text = ""
        self.view.endEditing(true)
    }
    
    
    /*func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }*/
    
 
}
