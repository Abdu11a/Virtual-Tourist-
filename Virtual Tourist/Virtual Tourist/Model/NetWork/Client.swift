//
//  Client.swift
//  Virtual Tourist
//
//  Created by Abdulla Aseed on 14/03/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Client : NSObject {
   
     var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init() {
        super.init()
    }
    private func getParameters(coordinate: CLLocationCoordinate2D) -> [String:AnyObject]  {
        
        let methodParameters = [
            Client.FlickrParameterKeys.Method: Client.FlickrParameterValues.SearchMethod,
            Client.FlickrParameterKeys.APIKey: Client.FlickrParameterValues.APIKey,
            Client.FlickrParameterKeys.Lat: coordinate.latitude,
            Client.FlickrParameterKeys.Lon: coordinate.longitude,
            Client.FlickrParameterKeys.SafeSearch: Client.FlickrParameterValues.UseSafeSearch,
            Client.FlickrParameterKeys.Extras: Client.FlickrParameterValues.MediumURL,
            Client.FlickrParameterKeys.Format: Client.FlickrParameterValues.ResponseFormat,
            Client.FlickrParameterKeys.PerPage: Client.FlickrParameterValues.PerPageValue,
            Client.FlickrParameterKeys.NoJSONCallback: Client.FlickrParameterValues.DisableJSONCallback
            ] as [String:AnyObject]
        return methodParameters
    }
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    func displayFlickerImage(_ coordinate : CLLocationCoordinate2D , completionHandler : @escaping (_ result: [[String:Any]], _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var methodParameters = getParameters(coordinate: coordinate)
        
        let request = URLRequest(url: flickrURLFromParameters(methodParameters))
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
           
            guard error == nil else {
                 completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "There was an error with your request: \(error?.localizedDescription ?? "")"] as [String : Any]))
                
                 return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode <= 299 && statusCode >= 200 else {
              
                 completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Your request returned a status code other than 2xx!"] as [String : Any]))
                return
            }
            guard let data = data else {
                 completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "No data was return !!"] as [String : Any]))
                
                return
            }
            
            let parsedResult : [String : AnyObject]!
            do { parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
                
            } catch {
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"] as [String : Any]))
                return
            }
            ///////////
            guard let stat = parsedResult[Client.FlickrResponseKeys.Status] as? String, stat == Client.FlickrResponseValues.OKStatus else {
                 completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Flickr API returned an error. See error code and message in \(String(describing: parsedResult))"] as [String : Any]))
                return
            }
            guard let photosDictionary = parsedResult[Client.FlickrResponseKeys.Photos] as? [String : AnyObject] else {
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Cannot find keys '\(Client.FlickrResponseKeys.Photos)"] as [String : Any]))
                
                return
            }
           
            
            guard let totalPages = photosDictionary[Client.FlickrResponseKeys.Pages] as? Int else {
             
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Cannot find key '\(Client.FlickrResponseKeys.Pages)"] as [String : Any]))
                return
            }
            ////////////////////////////////////////////////////
            let randomPageLimit  = Int(arc4random_uniform(UInt32(min(totalPages , 40)))) + 1
            let pagenumber = self.displayFlickerImage(methodParameters, withPageNumber: randomPageLimit, completionHandler: { (results, error) in
                completionHandler(results, error)
            })
        }
         task.resume()
        return task
    }
    
    private func displayFlickerImage(_ methodParameters : [String:AnyObject] , withPageNumber : Int, completionHandler : @escaping (_ result: [[String:Any]], _ error: NSError?) -> Void) -> URLSessionDataTask {
        
         var methodParametersWithePageNumber = methodParameters
        methodParametersWithePageNumber[Client.FlickrParameterKeys.Page] = withPageNumber as AnyObject?
        
        let request = URLRequest(url: flickrURLFromParameters(methodParametersWithePageNumber))
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                 completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "There was an error with your request: \(error?.localizedDescription ?? "")"] as [String : Any]))
                
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode <= 299 && statusCode >= 200 else {
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Your request returned a status code other than 2xx!"] as [String : Any]))
                return
            }
            guard let data = data else {
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "No data was returne !!"] as [String : Any]))
                
                return
            }
            let parsedResult : [String : AnyObject]!
            do { parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
                } catch {
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"] as [String : Any]))
                return
            }
            guard let stat = parsedResult[Client.FlickrResponseKeys.Status] as? String,
                stat == Client.FlickrResponseValues.OKStatus else {
                      completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Flickr API returned an error. See error code and message in \(String(describing: parsedResult))"] as [String : Any]))
                    return
            }
            guard let photosDictionary = parsedResult[Client.FlickrResponseKeys.Photos] as? [String : AnyObject] else {
                 completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Cannot find keys '\(Client.FlickrResponseKeys.Photos)' in \(String(describing: parsedResult))"] as [String : Any]))
                
                return
            }
            guard let photosArray = photosDictionary[Client.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
               
                completionHandler([[:]] , NSError(domain: "displayFlickerImageMethod", code: 1, userInfo: [NSLocalizedDescriptionKey : "Cannot find key '\(Client.FlickrResponseKeys.Photo)' in \(photosDictionary)"] as [String : Any]))
                return
            }
            completionHandler(photosArray , nil)
        }
        task.resume()
        return task
    }
    

    private func flickrURLFromParameters(_ parameters: [String : AnyObject]) -> URL{
        var component        = URLComponents()
        component.scheme     = Client.Constants.APIScheme
        component.host       = Client.Constants.APIHost
        component.path       = Client.Constants.APIPath
        component.queryItems = [URLQueryItem]()
        
        for (key , value) in parameters {
            let queryItems = URLQueryItem(name: key, value: "\(value)")
             component.queryItems!.append(queryItems)
        }
        return component.url!
    }
    
    

}
