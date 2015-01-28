//
//  ViewController.swift
//  4 - Directions
//
//  Created by Nicholas Furness on 1/27/15.
//  Copyright (c) 2015 Nicholas Furness. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController, AGSWebMapDelegate, AGSMapViewTouchDelegate {

    @IBOutlet weak var mapView: AGSMapView!
    
    let webMap = AGSWebMap(itemId: "34ef224e34fa4a9db6adc58716f5d588", credential: nil)
    var routeManager: RouteManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webMap.openIntoMapView(self.mapView)
        self.webMap.delegate = self
        
        self.mapView.touchDelegate = self
    }
    
    func mapView(mapView: AGSMapView!, didClickAtPoint screen: CGPoint, mapPoint mappoint: AGSPoint!, features: [NSObject : AnyObject]!) {
        var tappedFeature:AGSFeature? = nil
        for (_, layerFeatures) in features {
            if let feature = layerFeatures[0] as? AGSFeature {
                tappedFeature = feature
            }
        }
        
        if let destination = tappedFeature?.geometry? as? AGSPoint {
            let myPosition = self.mapView.locationDisplay.location.point
            self.routeManager.solveRoute(myPosition, destination: destination)
        }
    }
    
    func webMap(webMap: AGSWebMap!, didFailToLoadWithError error: NSError!) {
        UIAlertView(title: "Map Load Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func webMap(webMap: AGSWebMap!, didFailToLoadLayer layerInfo: AGSWebMapLayerInfo!, baseLayer: Bool, federated: Bool, withError error: NSError!) {
        UIAlertView(title: "Layer Load Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func webMapDidLoad(webMap: AGSWebMap!) {
        println("Web Map Loaded")
    }
    
    func didOpenWebMap(webMap: AGSWebMap!, intoMapView mapView: AGSMapView!) {
        self.routeManager = RouteManager(mapView: mapView)
        
        self.mapView.locationDisplay.startDataSource()
        self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.Off
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

