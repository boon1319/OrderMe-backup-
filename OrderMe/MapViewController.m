//
//  MapViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/18/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
     self.singletonObj = [SingletonClass sharedInstance];
    
    self.mapView.delegate = self;
    
    /////////////////////////////////////////////////
    ///////// Check for Internet connection /////////
    /////////////////////////////////////////////////
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        UIAlertView *errorView;
        
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
    }else{
        [self createAnnotation];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.lat = [self.currentLat floatValue];
    self.lng = [self.currentLng floatValue];
    [self zoomToPlace:self.lat :self.lng];    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.lat = [self.currentLat floatValue];
    self.lng = [self.currentLng floatValue];
    [self zoomToPlace:self.lat :self.lng];
}

- (void)zoomToPlace:(float)lat :(float)lng
{
    CLLocationCoordinate2D mapCenter = self.mapView.centerCoordinate;
    CLLocationCoordinate2D currentPoint;
    currentPoint.latitude = lat;
    currentPoint.longitude = lng;
    [self.mapView setCenterCoordinate:currentPoint];
    mapCenter = [self.mapView convertPoint:CGPointMake((self.mapView.frame.size.width/2), (self.mapView.frame.size.height/2)) toCoordinateFromView:self.mapView];
    MKCoordinateSpan span;
    span.latitudeDelta = .001;
    span.longitudeDelta = .001;
    //the .001 here represents the actual height and width delta
    MKCoordinateRegion region;
    region.center = currentPoint;
    region.span = span;
    
    [self.mapView setRegion:region animated:TRUE];
}

- (void)createAnnotation
{
    CLLocationCoordinate2D mapCenter = self.mapView.centerCoordinate;
    
    // set center to Atlanta, GA
    
    CLLocationCoordinate2D centerPoint;
    centerPoint.latitude = [self.currentLat floatValue];
    centerPoint.longitude = [self.currentLng floatValue];
    
    for (int i = 0; i < [self.singletonObj.nameArray count]; i++) {
        
        NSString *placeName = [self.singletonObj.nameArray objectAtIndex:i];
        NSString *placeAddress = [self.singletonObj.addressArray objectAtIndex:i];
        NSString *placePhone = [self.singletonObj.phoneArray objectAtIndex:i];
        float lat = [[self.singletonObj.latArray objectAtIndex:i] floatValue];
        float lng = [[self.singletonObj.lngArray objectAtIndex:i] floatValue];
        
        CLLocationCoordinate2D currentPoint;
        currentPoint.latitude = lat;
        currentPoint.longitude = lng;
        
        MapViewAnnotation *newAnnotation;
        
        if (!newAnnotation) {
            newAnnotation = [[MapViewAnnotation alloc] initWithLoction:currentPoint Title:placeName SubTitle:placeAddress Phone:placePhone];
            
            [self.mapView addAnnotation:newAnnotation];
        }
    }
    
    [self.mapView setCenterCoordinate:centerPoint];
    mapCenter = [self.mapView convertPoint:CGPointMake((self.mapView.frame.size.width/2), (self.mapView.frame.size.height/2)) toCoordinateFromView:self.mapView];
    MKCoordinateSpan span;
    span.latitudeDelta = .027;
    span.longitudeDelta = .027;
    //the .001 here represents the actual height and width delta
    MKCoordinateRegion region;
    region.center = centerPoint;
    region.span = span;
    
    [self.mapView setRegion:region animated:TRUE];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *pinIdentifier = @"myPin";
    
    if ([annotation isKindOfClass:[MapViewAnnotation class]])
    {
        MKPinAnnotationView *pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        if (!pin)
        {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        }
        else
        {
            pin.annotation = annotation;
        }
        
        UIImage *pinImage = [UIImage imageNamed:@"Roling.png"];
        
        [pin setImage:pinImage];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.enabled = YES;
        pin.rightCalloutAccessoryView = button;
        
        return pin;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapViewAnnotation *annotation = view.annotation;
    PlaceDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceDetailViewController"];
    detailVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    detailVC.placeName = annotation.title;
    detailVC.placeAddress = annotation.subTitle;
    detailVC.placePhone = annotation.phone;
    
    [self presentViewController:detailVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
