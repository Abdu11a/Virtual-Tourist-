//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Abdulla Aseed on 14/03/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
class AlbumViewController : UIViewController , MKMapViewDelegate , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource  {
     var dataController: ControlData!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollection: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var coordinate: CLLocationCoordinate2D!
    var photos: [Photo]!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayout(view.frame.size)
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        let predicate = NSPredicate(format: "pin == %@", pin)
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = predicate
                if let result = try? dataController.viewContext.fetch(fetchRequest){
            photos = result
        }
        
        activityIndicator.hidesWhenStopped = true

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        
        if photos.isEmpty {
            getFlickerImage()
        }
        

    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateFlowLayout(size)
    }
    @IBAction func newCollectionTapped(_ sender: Any) {
        pin.photos = nil
         try? self.dataController.viewContext.save()
        collectionView.reloadData()
        photos.removeAll()
        
        for photo in photos {
            dataController.viewContext.delete(photo)
        }
        getFlickerImage()
        
    }
    
    func showInfo(withTitle: String, withMessage: String, action: (() -> Void)? = nil){
        let controller = UIAlertController(title: withTitle, message : withMessage, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(controller , animated: true, completion: nil)
    }

    func getFlickerImage(){
        setUIEnabled(false)
        let  _ = Client.sharedInstance().displayFlickerImage(coordinate) {
            (photosArray, error) in
            if let error = error {
                
                self.showInfo(withTitle: "Wrong‼️", withMessage:"\(error.localizedDescription) 🤔")
                self.setUIEnabled(true)
            }
            else if photosArray.count == 0 {
                self.showInfo(withTitle: "Wrong‼️", withMessage:"No photos found for this location 🧐 ")
                self.setUIEnabled(true)
            }else if photosArray.count < 12 {
                self.showInfo(withTitle: "⁉️", withMessage:"This is The last Photo Collection for this location 😬 ")
                self.setUIEnabled(true)
            }
            for photo in photosArray{
                guard let imageUrlString = photo[Client.FlickrResponseKeys.MediumURL] as? String
                    else{
                        
                        self.setUIEnabled(true)
                        return
                }
                let imageUrl = URL(string: imageUrlString)
                
                guard let imageDtat = try? Data(contentsOf: imageUrl!)
                    else {
                        self.setUIEnabled(true)
                        return
                }
                
                let image  = Photo(context: self.dataController.viewContext)
                image.imageUrl = imageUrl
                image.rawPhoto = imageDtat
                image.pin = self.pin
                try? self.dataController.viewContext.save()
                self.photos.append(image)
                self.performUIUpdatesOnMain {
                    self.collectionView.reloadData()
                }
            }
            self.setUIEnabled(true)
            self.performUIUpdatesOnMain {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setUIEnabled(_ Enabled : Bool){
        performUIUpdatesOnMain {
            self.newCollection.isEnabled = Enabled
            
            if Enabled {
                self.newCollection.alpha = 1.0
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()
            } else {
                self.newCollection.alpha = 0.5
                self.activityIndicator.alpha = 1.0
                self.activityIndicator.startAnimating()
            }
        }
    }
    
     func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ImageViewCell.identifier , for: indexPath) as! ImageViewCell
        if let photo = photos[indexPath.row].rawPhoto{
            cell.imageCell.image = UIImage(data: photo)
        }
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataController.viewContext.delete(photos[indexPath.row])
        try? self.dataController.viewContext.save()
        photos.remove(at: indexPath.row)
        collectionView.reloadData()
    }
       private func updateFlowLayout(_ withSize: CGSize) {
        
        let landscape = withSize.width > withSize.height
        
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }

}


