//
//  RestaurantContactViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/18/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
#import "MenuViewController.h"
#import "MapViewController.h"

@interface RestaurantContactViewController : UITableViewController

@property (strong, nonatomic) SingletonClass *singletonObj;

@end
