//
//  mapsExtension.swift
//  Virtual Tourist
//
//  Created by Abdulla Aseed on 15/03/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
extension PinMapViewController   {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = false
            pinView?.animatesDrop = true
        } else {pinView?.annotation = annotation }
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
 
        guard let annotation = view.annotation else {
            return
        }
        mapView.deselectAnnotation(annotation, animated: true)
        let latitude = (annotation.coordinate.latitude)
        let longitude = (annotation.coordinate.longitude)

        if isEditing{
            ///////TODO:delet One Pin
            deleteAllData()
            print(latitude)
            print(longitude)
            mapView.removeAnnotation(annotation)
            view.reloadInputViews()
           return
        }
        
         let controller = self.storyboard!.instantiateViewController(withIdentifier: "PhotoAlbum") as? AlbumViewController
       
        controller?.coordinate = view.annotation?.coordinate
        for pin in pins {
            if pin.lat.isEqual(to: view.annotation?.coordinate.latitude.magnitude ?? 90){
                controller?.pin = pin
                
            }
        }
        controller?.dataController = dataController
        self.show(controller!, sender: nil)
        
        
       
    }
    
    
}
extension AlbumViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = false
            pinView?.animatesDrop = true
        } else {pinView!.annotation = annotation }
        
        return pinView
    }
}
