//
//  ViewController.swift
//  4 - Directions
//
//  Created by Nicholas Furness on 1/27/15.
//  Copyright (c) 2015 Nicholas Furness. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController, AGSWebMapDelegate {

    @IBOutlet weak var mapView: AGSMapView!
    
    let webMap = AGSWebMap(itemId: "34ef224e34fa4a9db6adc58716f5d588", credential: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webMap.openIntoMapView(self.mapView)
        self.webMap.delegate = self
    }
    
    func webMap(webMap: AGSWebMap!, didFailToLoadWithError error: NSError!) {
        UIAlertView(title: "Map Load Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func webMap(webMap: AGSWebMap!, didFailToLoadLayer layerInfo: AGSWebMapLayerInfo!, baseLayer: Bool, federated: Bool, withError error: NSError!) {
        UIAlertView(title: "Layer Load Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

