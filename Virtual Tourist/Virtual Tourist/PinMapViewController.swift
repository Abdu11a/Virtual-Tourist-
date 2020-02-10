//
//  PinMapViewController.swift
//  Virtual Tourist
//
//  Created by Abdulla Aseed on 14/03/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PinMapViewController: UIViewController , UIGestureRecognizerDelegate , MKMapViewDelegate {
     var dataController: ControlData!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    var pins: [Pin] = []
   
    override func viewWillAppear(_ animated: Bool) {
        addpin()
        view.reloadInputViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(tappedToAddPin))
        gesture.delegate = self
        mapView.addGestureRecognizer(gesture)
        
        navigationItem.rightBarButtonItem = editButtonItem
        deleteView.isHidden = true
        
        let fetshRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetshRequest){
            pins = result
            mapView.removeAnnotations(mapView.annotations)
            addpin()
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deleteView.isHidden = !editing
    }
    
    @objc func tappedToAddPin(gestureReconizer : UIGestureRecognizer){
        if gestureReconizer.state == UIGestureRecognizer.State.began{
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            let pin = Pin(context: dataController.viewContext)
            pin.lon = coordinate.longitude.magnitude
            pin.lat = coordinate.latitude.magnitude
            
            do{
               try dataController.viewContext.save()
            }catch{
                print(error.localizedDescription)
            }
            pins.append(pin)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
        }
    }
    
    func deleteAllData() {
        
        let managedContext =  dataController.viewContext.persistentStoreCoordinator
        let context = dataController.viewContext
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedContext?.execute(batchDeleteRequest, with: context)
        }
        catch {
            print(error)
        }}
  
    
    func addpin(){
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for pin in pins {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.lat), longitude: CLLocationDegrees(pin.lon))
            let annotation = MKPointAnnotation()
               annotation.coordinate = coordinate
               annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    
}





