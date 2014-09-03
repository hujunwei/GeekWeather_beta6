//
//  ViewController.swift
//  Geek Weather
//
//  Created by Junwei Hu on 8/30/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    let location_manager:CLLocationManager = CLLocationManager()
    var jsonResult:NSDictionary? = nil
    @IBOutlet var location : UILabel!
    @IBOutlet var icon : UIImageView!
    @IBOutlet var loadingLabel : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var loadingIndicator : UIActivityIndicatorView!
    @IBOutlet var transButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //println(self.location_manager.locationServicesEnabled)
        self.location_manager.delegate = self;
        self.location_manager.desiredAccuracy = kCLLocationAccuracyBest
        if (check_version8() ) {
            location_manager.requestAlwaysAuthorization()
        }
        location_manager.startUpdatingLocation()
    }

    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations:[AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as CLLocation
        if (location.horizontalAccuracy > 0) {
            self.location_manager.stopUpdatingLocation()
            println(location.coordinate)
            self.updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        else {
            self.loadingLabel.text = "finding location failed"
        }
    }
    
    func updateWeatherInfo(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat":latitude, "lon":longitude, "cnt":0]
        println(params)
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                self.jsonResult = responseObject as NSDictionary!
                self.updateUISuccess(responseObject as NSDictionary!)
                //let bashVC:BashViewController = BashViewController()
                //self.presentViewController(bashVC, animated:true, completion: nil)

                //println("origin \(self.view)")
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                self.loadingLabel.text = "Internet appears down!"
            })
        
    }
    
    func updateUISuccess(jsonResult:NSDictionary!) {
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
        loadingLabel.text = nil
        //self.transButton.font = UIFont(name:"courier", size:20)
        if let tempResult = ((jsonResult["main"]? as NSDictionary)["temp"] as? Double) {
            
            // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
            var temperature: Double
            if let sys = (jsonResult["sys"]? as? NSDictionary) {
                if let country = (sys["country"] as? String) {
                    if (country == "US") {
                        temperature = round(tempResult - 273.15)
                    }
                    else {
                        // Otherwise, convert temperature to Celsius
                        temperature = round(tempResult - 273.15)
                    }
                    
                    // Is it a bug of Xcode 6? can not set the font size in IB.
                    //self.temperature.font = UIFont.boldSystemFontOfSize(60)
                    self.temperature.font = UIFont(name: "courier", size : 30)
                    self.temperature.text = "\(temperature)°"
                }
                //Update location
                if let name = jsonResult["name"] as? String {
                    self.location.font = UIFont(name: "courier", size : 20)
                    var title:NSString = "Here is " + name;
                    self.location.text = title
                }
                //Uppdate weather
                if let weather = jsonResult["weather"]? as? NSArray {
                    var condition = (weather[0] as NSDictionary)["id"] as Int
                    var sunrise = sys["sunrise"] as Double
                    var sunset = sys["sunset"] as Double
                    var nightTime = false
                    var now = NSDate().timeIntervalSince1970
                    if (now < sunrise || now > sunset) {
                        nightTime = true
                    }
                    //update icon
                    self.updateWeatherIcon(condition, nightTime: nightTime)
                    return
                }
            }
            
            
        }
        else {
            self.loadingLabel.text = "loading weather failed"
        }
        
    }
    func check_version8() -> Bool {
        return UIDevice.currentDevice().systemVersion == "8.0"
    }

    
    // Converts a Weather Condition into one of our icons.
    // Refer to: http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
    func updateWeatherIcon(condition: Int, nightTime: Bool) {
        // Thunderstorm
        if (condition < 300) {
            if nightTime {
                self.icon.image = UIImage(named: "tstorm1_night")
            } else {
                self.icon.image = UIImage(named: "tstorm1")
            }
        }
            // Drizzle
        else if (condition < 500) {
            self.icon.image = UIImage(named: "light_rain")
        }
            // Rain / Freezing rain / Shower rain
        else if (condition < 600) {
            self.icon.image = UIImage(named: "shower3")
        }
            // Snow
        else if (condition < 700) {
            self.icon.image = UIImage(named: "snow4")
        }
            // Fog / Mist / Haze / etc.
        else if (condition < 771) {
            if nightTime {
                self.icon.image = UIImage(named: "fog_night")
            } else {
                self.icon.image = UIImage(named: "fog")
            }
        }
            // Tornado / Squalls
        else if (condition < 800) {
            self.icon.image = UIImage(named: "tstorm3")
        }
            // Sky is clear
        else if (condition == 800) {
            if (nightTime){
                self.icon.image = UIImage(named: "sunny_night") // sunny night?
            }
            else {
                self.icon.image = UIImage(named: "sunny")
            }
        }
            // few / scattered / broken clouds
        else if (condition < 804) {
            if (nightTime){
                self.icon.image = UIImage(named: "cloudy2_night")
            }
            else{
                self.icon.image = UIImage(named: "cloudy2")
            }
        }
            // overcast clouds
        else if (condition == 804) {
            self.icon.image = UIImage(named: "overcast")
        }
            // Extreme
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
            self.icon.image = UIImage(named: "tstorm3")
        }
            // Cold
        else if (condition == 903) {
            self.icon.image = UIImage(named: "snow5")
        }
            // Hot
        else if (condition == 904) {
            self.icon.image = UIImage(named: "sunny")
        }
            // Weather condition is not available
        else {
            self.icon.image = UIImage(named: "dunno")
        }
    }
    
    //transfer json result to the BashVC
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var bvc:BashViewController = segue.destinationViewController as BashViewController
        bvc.jsonResult = self.jsonResult
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //handle error updating location
    func locationManager(manager:CLLocationManager!, didFailWithError error:NSError! ){
        println(error)
    }
    
}

