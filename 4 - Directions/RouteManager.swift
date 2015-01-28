//
//  RouteManager.swift
//  iOS Apps
//
//  Created by Nicholas Furness on 1/25/15.
//  Copyright (c) 2015 Nicholas Furness. All rights reserved.
//

import Foundation
import ArcGIS

private let agolRouteURL = "http://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World"

class RouteManager : NSObject, AGSRouteTaskDelegate {
    weak var mapView:AGSMapView!
    
    let routeTask = AGSRouteTask(URL: NSURL(string: agolRouteURL), credential: demoCredential)
    var routeParams: AGSRouteTaskParameters!
    
    let routeGraphics = AGSGraphicsLayer()

    init(mapView:AGSMapView) {
        super.init()
        
        self.routeTask.delegate = self
        
        self.mapView = mapView
        mapView.addMapLayer(self.routeGraphics)
        
        self.routeTask.retrieveDefaultRouteTaskParameters()
    }
    
    func solveRoute(start: AGSPoint, destination: AGSPoint) {
        let startFeature = AGSGraphic(geometry: start, symbol: nil, attributes: nil)
        let destinationFeature = AGSGraphic(geometry: destination, symbol: nil, attributes: nil)
        self.routeParams.setStopsWithFeatures([startFeature, destinationFeature])
        self.routeTask.solveWithParameters(self.routeParams)
    }

    func routeTask(routeTask: AGSRouteTask!, operation op: NSOperation!, didRetrieveDefaultRouteTaskParameters routeParams: AGSRouteTaskParameters!) {
        println("Got default parameters!")
        
        routeParams.returnDirections = true
        routeParams.returnRouteGraphics = true
        routeParams.returnStopGraphics = true
        routeParams.outSpatialReference = self.mapView.spatialReference
        self.routeParams = routeParams
    }
    
    func routeTask(routeTask: AGSRouteTask!, operation op: NSOperation!, didFailToRetrieveDefaultRouteTaskParametersWithError error: NSError!) {
        println("Failed to get default parameters: \(error)")
    }

    func routeTask(routeTask: AGSRouteTask!, operation op: NSOperation!, didSolveWithResult routeTaskResult: AGSRouteTaskResult!) {
        self.routeGraphics.removeAllGraphics()
        
        if let result = routeTaskResult.routeResults[0] as? AGSRouteResult {
            result.routeGraphic.symbol = AGSSimpleLineSymbol(color: UIColor.orangeColor().colorWithAlphaComponent(0.5), width: 4)
            self.routeGraphics.addGraphic(result.routeGraphic)
            let env = result.routeGraphic.geometry.envelope.mutableCopy() as AGSMutableEnvelope
            env.expandByFactor(1.2)
            self.mapView.zoomToGeometry(env, withPadding: 0, animated: true)
            println("Added route results")
            for direction in result.directions.graphics {
                if let dir = direction as? AGSDirectionGraphic {
                    println(dir.text)
                }
            }
        }
    }
    
    func routeTask(routeTask: AGSRouteTask!, operation op: NSOperation!, didFailSolveWithError error: NSError!) {
        println("Failed to solve route: \(error.localizedDescription)")
    }
}