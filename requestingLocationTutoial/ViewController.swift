//
//  ViewController.swift
//  requestingLocationTutoial
//
//  Created by YY on 2019/3/8.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        definesPresentationContext = true
    }

    @IBAction func getLocation(_ sender: UIButton) {
        
        let mgr = LocationManager.sharedInstance
        mgr.config()
        
    }
    
    @IBAction func check(_ sender: UIButton) {
        
        let mgr = LocationManager.sharedInstance
        let success = mgr.isLocationServiceSuccess { (alertControllers) in
            for ctrs in alertControllers {
                self.present(ctrs, animated: true, completion: nil)
            }
        }
        print(success)
        
    }
    
}
