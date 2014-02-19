//
//  SingletonClass.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/11/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "SingletonClass.h"

@implementation SingletonClass

static SingletonClass *sharedSingletonClass = nil;

+(SingletonClass*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedSingletonClass == nil) {
            sharedSingletonClass = [[super allocWithZone:NULL] init];
        }
    }
    return sharedSingletonClass;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.nameArray = [[NSArray alloc] initWithObjects:@"Nan Thai Fine Dining", @"Rice Bowl Thai & Sushi", @"Surin Of Thailand", @"Tamarind Seed", @"Tuk Tuk Thai Food Loft", nil];
        self.idArray = [[NSArray alloc] initWithObjects:@"258682", @"302065", @"248505", @"258690", @"293620", nil];
        self.addressArray = [[NSArray alloc] initWithObjects:@"1350 Spring St NW, Atlanta GA 30309", @"2900 Peachtree Rd NE, Atlanta GA 30305", @"810 N Highland Ave Ne, Atlanta GA 30306", @"1197 Peachtree St Ne, Atlanta GA 30361", @"1745 Peachtree St Ne, Atlanta GA 30309", nil];
        self.phoneArray = [[NSArray alloc] initWithObjects:@"(404) 870-9933", @"(404) 841-2992", @"(404) 442-7522", @"(404) 873-4888", @"(678) 539-6181", nil];
        self.imageArray = [[NSArray alloc] initWithObjects:@"nanthai.png", @"ricebowl.jpg", @"surinofthailand", @"tamarind.png", @"tuktukthai.jpeg", nil];
        self.latArray = [[NSArray alloc] initWithObjects:@"33.79151610", @"33.83365050", @"33.77662640",  @"33.7868980", @"33.8001750", nil];
        self.lngArray = [[NSArray alloc] initWithObjects:@"-84.38937489999999", @"-84.3832590", @"-84.3526270", @"-84.38273190", @"-84.39215779999999", nil];
        
        ///////////////////////////////////////////////////
        // Use this link link to get the place coordinate from Google by using place address in the link.
        // https://maps.googleapis.com/maps/api/place/textsearch/json?query=<ADDRESS>&sensor=true&key=AIzaSyAw0m3prCKzqP-zrWauU7DsXJgMDnbQY-Y
        ///////////////////////////////////////////////////
        
        self.gblTypeArray = [[NSMutableArray alloc] init];
        
        self.badgeCount = [[NSString alloc]init];
        self.restaurantID = [[NSString alloc]init];
        self.restaurantName = [[NSString alloc]init];
        
        self.gblNewOrderArray = [[NSMutableArray alloc]init];
        self.orderDate = [[NSString alloc]init];
        self.gblOldOrderArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
