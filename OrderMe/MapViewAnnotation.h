//
//  MapViewAnnotation.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/12/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subTitle;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLoction:(CLLocationCoordinate2D)coord Title:(NSString*)ttl SubTitle:(NSString*)subt Phone:(NSString*)pho;

@end
