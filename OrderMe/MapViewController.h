//
//  MapViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/18/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SingletonClass.h"
#import "MapViewAnnotation.h"
#import "PlaceDetailViewController.h"
#import "Reachability.h"

@interface MapViewController : UIViewController <MKAnnotation,MKMapViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (strong, nonatomic) NSData *dataJSON;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSString *currentLat;
@property (strong, nonatomic) NSString *currentLng;

@property float lat;
@property float lng;

@end
