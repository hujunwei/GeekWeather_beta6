//
//  BashViewController.swift
//  Geek Weather
//
//  Created by Junwei Hu on 8/31/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation



class BashViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {

    var login_str:NSString = ""
    var command:String = ""
    var lastText:NSString = ""
    var jsonResult:NSDictionary! = nil
    @IBOutlet var inputBox : UITextField!
    @IBOutlet var backButton : UIButton!
    @IBOutlet var Bash : UITextView!
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        //let command_str = command.substringFromIndex(4)
        command = inputBox.text
        if (command != "") {
            self.Bash.text = "\(lastText)\nGW$ \(command)"
            lastText = self.Bash.text
            dispatch_command(command);
            //clear inputBox
            inputBox.text = ""
        }
        println(inputBox.text)
        inputBox.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        //inputBox.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.testLabel.text = "success!"
        //println("haha")
        self.inputBox.delegate = self
        self.inputBox.text = ""
        println("sended info \(self.jsonResult.description)")
        
        //self.Bash.font = UIFont(name:"courier", size:14)
        var date_formatter:NSDateFormatter = NSDateFormatter()
        var time_formatter:NSDateFormatter = NSDateFormatter()
        var date_info:NSDate = NSDate()
        date_formatter.dateFormat = "YYYY-MM-dd'"
        time_formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var date_info_str:NSString = date_formatter.stringFromDate(date_info)
        var time_info_str:NSString = time_formatter.stringFromDate(date_info)
        self.lastText = "Last login: \(date_info_str) \(time_info_str) on ttys000"
        self.login_str = "Last login: \(date_info_str) \(time_info_str) on ttys000"
        self.Bash.text = "\(lastText)"
        //self.backButton.font = UIFont(name:"courier", size:13)
        //self.dismissModalViewControllerAnimated(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //parse command and giving out put
    func dispatch_command(command:NSString) {
        //clear all bash
        if (command == "clear") {
            lastText = self.login_str
            Bash.text = self.login_str
        }
        //show temperature
        else if (command == "gw temperature" || command == "gw temp") {
            if let tempResult = ((self.jsonResult["main"] as NSDictionary)["temp"] as? Double) {
                self.Bash.text = "\(lastText)\n[Temperature] : \(round(tempResult - 273.15))°"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : weather info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        //show all the info
        else if (command == "gw json") {
            if let tempResult = (self.jsonResult as NSDictionary!) {
                self.Bash.text = "\(lastText)\n[Json] : \(tempResult.description)°"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : json info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "gw from") {
            if let tempResult = (self.jsonResult["base"] as? String) {
                self.Bash.text = "\(lastText)\n[base] : \(tempResult)"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : base info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "gw clouds") {
            if let tempResult = (self.jsonResult["clouds"] as NSDictionary) ["all"] as? Int{
                self.Bash.text = "\(lastText)\n[Clouds] : \(tempResult + 0)%"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : clouds info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "gw location" || command == "gw loc") {
            if let tempResult = (self.jsonResult["coord"] as NSDictionary) ["lat"] as? Double {
                if let tempResult2 = (self.jsonResult["coord"] as NSDictionary) ["lon"] as? Double {
                    self.Bash.text = "\(lastText)\n[Location] : latitude:\(tempResult + 0), logitude:\(tempResult2 + 0)"
                    lastText = self.Bash.text
                }
                else {
                    self.Bash.text = "\(lastText)\n- Geek Weather - : location info not applicable \(command)"
                    lastText = self.Bash.text
                }
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : location info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if  (command == "gw humidity"){
            if let tempResult = ((self.jsonResult["main"] as NSDictionary)["humidity"] as? Double){
                self.Bash.text = "\(lastText)\n[Humidity] : \(tempResult + 0)%"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : humidity info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if  (command == "gw pressure"){
            if let tempResult = ((self.jsonResult["main"] as NSDictionary)["pressure"] as? Double){
                self.Bash.text = "\(lastText)\n[Pressure] : \(tempResult + 0)hPa"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : pressure info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "gw temprange" || command == "gw tpr") {
            if let tempResult = (self.jsonResult["main"] as NSDictionary) ["temp_max"] as? Double {
                if let tempResult2 = (self.jsonResult["main"] as NSDictionary) ["temp_min"] as? Double {
                    self.Bash.text = "\(lastText)\n[TemperatureRange] : temp_max: \(round(tempResult - 273.15))°, temp_min: \(round(tempResult2 - 273.15))°"
                    lastText = self.Bash.text
                }
                else {
                    self.Bash.text = "\(lastText)\n- Geek Weather - : temperature range info not applicable \(command)"
                    lastText = self.Bash.text
                }
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : temperature range info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if  (command == "gw city") {
            if let tempResult = self.jsonResult["name"] as? String{
                self.Bash.text = "\(lastText)\n[City] : \(tempResult)"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : city info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "gw weather") {
            if let weather = jsonResult["weather"]? as? NSArray {
                var condition = (weather[0] as NSDictionary)["description"] as String
                self.Bash.text = "\(lastText)\n[Weather] : \(condition)"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : weather info not applicable \(command)"
                lastText = self.Bash.text
            }

        }
        else if (command == "gw windspeed" || command == "gw wds") {
            if let tempResult = ((self.jsonResult["wind"] as NSDictionary)["speed"] as? Double) {
                self.Bash.text = "\(lastText)\n[WindSpeed] : \(tempResult + 0)mps"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : windspeed info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "gw winddirection" || command == "gw wdr") {
            if let tempResult = ((self.jsonResult["wind"] as NSDictionary)["deg"] as? Double) {
                self.Bash.text = "\(lastText)\n[WindDirection] : \(tempResult + 0)(meteorological)"
                lastText = self.Bash.text
            }
            else {
                self.Bash.text = "\(lastText)\n- Geek Weather - : winddirection info not applicable \(command)"
                lastText = self.Bash.text
            }
        }
        else if (command == "help") {
            let helpStr =  "\n'gw temperature' aka 'gw temp' --- get temperature of today\n'gw json' --- get all infomation as json format\n'gw from' --- get information of which weather station provides information\n'gw clouds' --- get probability of the clouds\n'gw location' aka 'gw loc' --- get latitude and longetude of the position\n'gw humidity' --- get percentage of humidity\n'gw pressure' --- get atmosphere pressure\n'gw temprange' aka 'gw tpr' --- get max & min temperature of today\n'gw city' --- get location name\n'gw weather' --- get weather condition\n'gw windspeed' aka 'gw wds' --- get wind speed\n'gw winddirection' aka 'gw wdr' --- get wind direction\n'clear' --- clear all text"
            self.Bash.text = "\(lastText)\n[Help] : all commands \(helpStr)"
            lastText = self.Bash.text
        }
        else {
            self.Bash.text = "\(lastText)\n[Geek Weather] : 404 command not found: \(command)"
            lastText = self.Bash.text
        }
    }



}