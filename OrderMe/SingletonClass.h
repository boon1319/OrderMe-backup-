//
//  SingletonClass.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/11/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonClass : NSObject

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *idArray;
@property (strong, nonatomic) NSArray *addressArray;
@property (strong, nonatomic) NSArray *phoneArray;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *latArray;
@property (strong, nonatomic) NSArray *lngArray;

@property(nonatomic, strong) NSMutableArray *gblTypeArray;

@property(nonatomic, strong) NSString *badgeCount;
@property(nonatomic, strong) NSString *restaurantID;
@property(nonatomic, strong) NSString *restaurantName;

@property(nonatomic, strong) NSMutableArray *gblNewOrderArray;
@property(nonatomic, strong) NSString *orderDate;
@property(nonatomic, strong) NSMutableArray *gblOldOrderArray;

+(SingletonClass*)sharedInstance;

@end
