//
//  JSQLocationMediaItem.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation
import MapKit

public typealias JSQLocationMediaItemCompletionBlock = (() -> Void)

public class JSQLocationMediaItem: JSQMediaItem, JSQMessageMediaData, MKAnnotation, NSCoding, NSCopying {

    public var location: CLLocation? {
        
        didSet {
            
            self.set(self.location, completion: nil)
            self.cachedMapImageView = nil
        }
    }
    
    private var cachedMapSnapshotImage: UIImage?
    private var cachedMapImageView: UIImageView?
    
    // MARK: - Initialization
    
    public required init() {
        
        super.init()
    }
    
    public required init(location: CLLocation?) {
        
        self.location = location
        self.cachedMapImageView = nil
        
        super.init()
    }
    
    public required init(maskAsOutgoing: Bool) {
        
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    public override var appliesMediaViewMaskAsOutgoing: Bool {
        
        didSet {
            
            self.cachedMapSnapshotImage = nil
            self.cachedMapImageView = nil
        }
    }
    
    override func clearCachedMediaViews() {
        
        super.clearCachedMediaViews()
        
        self.cachedMapImageView = nil
    }
    
    // MARK: - Map snapshot
    
    public func set(location: CLLocation?, completion: JSQLocationMediaItemCompletionBlock?) {
        
        self.set(location, region: location != nil ? MKCoordinateRegionMakeWithDistance(location!.coordinate, 500, 500) : nil, completion: completion)
    }
    
    func set(location: CLLocation?, region: MKCoordinateRegion?, completion: JSQLocationMediaItemCompletionBlock?) {
        
        if location != self.location {

            self.location = location?.copy() as? CLLocation
        }

        self.cachedMapSnapshotImage = nil
        self.cachedMapImageView = nil
        
        if let location = location,
            let region = region {

            self.createMapViewSnapshot(location, coordinateRegion: region, completion: completion)
        }
    }
    
    func createMapViewSnapshot(location: CLLocation, coordinateRegion region: MKCoordinateRegion, completion: JSQLocationMediaItemCompletionBlock?) {
        
        let options = MKMapSnapshotOptions()
        options.region = region
        options.size = self.mediaViewDisplaySize
        options.scale = UIScreen.mainScreen().scale
        
        let snapShotter = MKMapSnapshotter(options: options)
        
        snapShotter.startWithQueue(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), completionHandler: { (snapshot, error) -> Void in
            
            if error != nil {
                
                println("\(__FUNCTION__) Error creating map snapshot: \(error)")
                return
            }
            
            let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            var coordinatePoint = snapshot.pointForCoordinate(location.coordinate)
            let image: UIImage = snapshot.image
            
            coordinatePoint.x += pin.centerOffset.x - (CGRectGetWidth(pin.bounds) / 2)
            coordinatePoint.y += pin.centerOffset.y - (CGRectGetHeight(pin.bounds) / 2)
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.drawAtPoint(CGPointZero)
            pin.image.drawAtPoint(coordinatePoint)
            self.cachedMapSnapshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let completion = completion {
            
                dispatch_async(dispatch_get_main_queue(), completion)
            }
        })
    }
    
    // MARK: - MKAnnotation
    
    public var coordinate: CLLocationCoordinate2D {
        
        get {
            
            return self.location!.coordinate
        }
    }
    
    // MARK: - JSQMessageMediaData protocol
    
    public override var mediaView: UIView? {
        
        get {
            
            if let location = self.location,
                let cachedMapSnapshotImage = self.cachedMapSnapshotImage {
                    
                if let cachedMapImageView = self.cachedMapImageView {
                 
                    return cachedMapImageView
                }
                    
                let imageView = UIImageView(image: cachedMapSnapshotImage)
                imageView.contentMode = .ScaleAspectFill
                imageView.clipsToBounds = true
                
                JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
                self.cachedMapImageView = imageView
                
                return self.cachedMapImageView
            }
            
            return nil
        }
    }
    
    public override var mediaHash: Int {
        
        get {
            
            return self.hash
        }
    }
    
    // MARK: - NSObject
    
    public override func isEqual(object: AnyObject?) -> Bool {
        
        if !super.isEqual(object) {
            
            return false
        }
        
        if let locationItem = object as? JSQLocationMediaItem {
            
            if self.location == nil && locationItem.location == nil {
                
                return true
            }
            
            if let location = locationItem.location {
            
                return self.location?.distanceFromLocation(location) == 0
            }
        }
        
        return false
    }
    
    public override var hash:Int {
        
        get {
            
            return super.hash^(self.location?.hash ?? 0)
        }
    }
    
    public override var description: String {
        
        get {
            
            return "<\(self.dynamicType): location=\(self.location), appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"
        }
    }
    
    // MARK: - NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.location = aDecoder.decodeObjectForKey("location") as? CLLocation
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        
        super.encodeWithCoder(aCoder)
        
        aCoder.encodeObject(self.location, forKey: "location")
    }
    
    // MARK: - NSCopying
    
    public override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copy = self.dynamicType(location: self.location)
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing
        return copy
    }
}