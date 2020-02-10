//
//  FlickrParameter.swift
//  Virtual Tourist
//
//  Created by Abdulla Aseed on 14/03/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit

extension Client {
    struct FlickrParameterKeys {
        static let NoJSONCallback   = "nojsoncallback"
        static let SafeSearch       = "safe_search"
        static let Lat              = "lat"
        static let Lon              = "lon"
        static let Page             = "page"
        static let PerPage          = "per_page"
        static let Method           = "method"
        static let APIKey           = "api_key"
        static let GalleryID        = "gallery_id"
        static let Extras           = "extras"
        static let Format           = "format"
        
    }
    
    
    struct FlickrParameterValues {
        static let SearchMethod         = "flickr.photos.search"
        static let ResponseFormat       = "json"
        static let DisableJSONCallback  = "1"
        static let GalleryPhotosMethod  = "flickr.galleries.getPhotos"
        static let APIKey               = "5fe2d1ce187d6028473bb9ada1507555"  
        static let MediumURL            = "url_m"
        static let UseSafeSearch        = "1"
        static let PerPageValue         = "26"
    }
}
