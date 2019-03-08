//
//  LocationManager.swift
//  requestingLocationTutoial
//
//  Created by YY on 2019/3/8.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {

    var city: String = "Undefault"
    private let locationMgr = CLLocationManager()
    
    static let sharedInstance = LocationManager()
    private override init() {}
    
    func config() {
        
        guard isLocationServiceEnabled() else {
            return
        }
        
        let status  = CLLocationManager.authorizationStatus()

        // 用户没有决定是否使用定位服务
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.distanceFilter = 1000.0
        locationMgr.startUpdatingLocation()
    }
    
    // 检查整个手机定位系统是否可用
    private func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            return true
        }else {
            return false
        }
    }
    
    private func isLocationServiceOpen() -> Bool {
        // denied 被用户禁止
        // restricted 活动受限
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            return false
        } else {
            return true
        }
    }
    
    func isLocationServiceSuccess(handler: (_ actions: [UIAlertController])->()) -> Bool {
        var arts = [UIAlertController]()
        if !isLocationServiceEnabled() { // 手机定位没开
            // 添加一个alertContrller 跳转手机定位设置
        }
        if !isLocationServiceOpen() { // app定位没开
            let alert = combineAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", open: UIApplication.openSettingsURLString)
            arts.append(alert)
        }
        if arts.count > 0 {
            handler(arts)
            return false
        }
        
        if city == "Undefault" { // 城市获取失败
            config()
        }
        return true
    }
    
    func combineAlertController(title: String, message: String, open: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.openAppSetting(str: open)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    // UIApplication.openSettingsURLString --- app 定位
    func openAppSetting(str: String) {
        guard let url = URL(string: str) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension LocationManager : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationMgr.stopUpdatingLocation()
        let currentLocation = locations.last
        let geoCoder = CLGeocoder()
        
//        let userdefault = UserDefaults.standard
//        let userDefaultLanguages = userdefault.object(forKey: "AppleLanguages")
//        userdefault.set(NSArray(objects: "zh-Hans-CN"), forKey: "AppleLanguages")

        geoCoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
            
            if (error != nil) {print("reverse geodcode fail:" +  "\(error?.localizedDescription ?? "")")}
            
            let placeMark = placemarks?.last
    
            if let cty = placeMark?.locality {
                self.city = cty
            }else {
                self.city = placeMark?.administrativeArea ?? "Undefault"
            }
            
            print(self.city)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
    }
}
