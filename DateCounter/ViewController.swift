//
//  ViewController.swift
//  DateCounter
//
//  Created by John Bäckström on 26/01/16.
//  Copyright © 2016 se.johnphoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CurrentDateLabel: UILabel!
    @IBOutlet weak var ChosenDateLabel: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var diffTextView: UITextField!
    
    var currentDate: NSDate!
    var dateFormatter: NSDateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.addDoneButtonOnKeyboard()

        
        self.upDate(DatePicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func upDate(sender: UIDatePicker) {
        let incommingDate = sender.date.resetTime()
        
        upDateRelatedViews(incommingDate)
        
        let difference = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: currentDate, toDate: incommingDate, options: []).day
        updateDiff(difference)
        
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        let minus: UIBarButtonItem = UIBarButtonItem(title: "- (Minus)", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("minusClick"))
        
        var items = [UIBarButtonItem]()
        items.append(minus)
        items.append(flexSpace)
        
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.diffTextView.inputAccessoryView = doneToolbar
        self.diffTextView.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.upDateFromDiff()
        self.diffTextView.resignFirstResponder()
        self.diffTextView.resignFirstResponder()
    }
    
    func minusClick(){

        if (self.diffTextView.text!.hasPrefix("-")){
            self.diffTextView.text = String(self.diffTextView.text!.characters.dropFirst());
        } else {
            self.diffTextView.text = String(format: "-%@", self.diffTextView.text!)
        }
        
    }
    
    func upDateRelatedViews(newDate:NSDate){
        currentDate = NSDate().resetTime()
        let currentDateStr = dateFormatter.stringFromDate(currentDate)
        CurrentDateLabel.text = currentDateStr
        let strDate = dateFormatter.stringFromDate(newDate)
        ChosenDateLabel.text = strDate
        
        DatePicker.date = newDate;
    }
    
    func upDateFromDiff(){
        let value:String = self.diffTextView.text != nil ? self.diffTextView.text! : "0"
        let diff:Int = Int(value) != nil ? Int(value)!: 0
        let newChosenDate:NSDate = NSDate().resetTime().dateByAddingTimeInterval(60*60*24*Double(diff))
        upDateRelatedViews(newChosenDate)
        updateDiff(diff)
        
    }
    
    func updateDiff(diff:Int){
        self.diffTextView.text = String(diff)
    }


}

extension NSDate {
    
    func resetTime() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(([.Day, .Month, .Year]), fromDate: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        
        return calendar.dateFromComponents(components)!
    }
    
}