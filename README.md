# Virtual-Tourist-

![weather Icon](https://github.com/Abdu11a/Virtual-Tourist-/blob/master/Virtual%20Tourist/Virtual%20Tourist%20PHOTO/APP%20ICON.png)


## Overview
app that downloads and stores images from Flickr. The app will allow users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.


**Locations Map** : Allows the user to drop pins around the world


<img src="https://github.com/Abdu11a/Virtual-Tourist-/blob/master/Virtual%20Tourist/Virtual%20Tourist%20PHOTO/photo-1.png" width=400>

When the app first starts it will open to the map view. Users will be able to zoom and scroll around the map using standard pinch and drag gestures.
The center of the map and the zoom level should be persistent. If the app is turned off, the map should return to the same state when it is turned on again.
Tapping and holding the map drops a new pin. Users can place any number of pins on the map.
When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.




**Photo Album** : Allows the users to download and edit an album for a location 

<img src="https://github.com/Abdu11a/Virtual-Tourist-/blob/master/Virtual%20Tourist/Virtual%20Tourist%20PHOTO/photo-2.png" width=400>


If the user taps a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin.
If no images are found a “No Images” label will be displayed.
If there are images, then they will be displayed in a collection view.
While the images are downloading, the photo album is in a temporary “downloading” state in which the New Collection button is disabled. The app should determine how many images are available for the pin location, and display a placeholder image for each.

#### Alert Action, when some Network connection issues happen .
 <img src="https://github.com/Abdu11a/Virtual-Tourist-/blob/master/Virtual%20Tourist/Virtual%20Tourist%20PHOTO/photo-3.png" width=400>
 
 ## Requirements to run this app

**To run this app you need to [Virtual-Tourist](https://github.com/Abdu11a/Virtual-Tourist-/raw/master/Virtual%20Tourist.zip).**

### Versions:

- [![Xcode Version](https://img.shields.io/badge/Xcode-10+-success.svg)](https://swift.org) 
- [![Swift Version](https://img.shields.io/badge/Swift-4+-success.svg)](https://swift.org)
- [![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://swift.org)
 
