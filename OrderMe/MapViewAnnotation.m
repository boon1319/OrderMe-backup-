//
//  MapViewAnnotation.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/12/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title;
@synthesize coordinate;
@synthesize subTitle;
@synthesize phone;

- (id)initWithLoction:(CLLocationCoordinate2D)coord Title:(NSString*)ttl SubTitle:(NSString*)subt Phone:(NSString*)pho;
{
	self = [super init];
	if (self) {
        coordinate = coord;
        title = ttl;
        subTitle = subt;
        phone = pho;
    }
	return self;
}


@end
