//
//  MenuViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/11/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
#import "ItemDetailViewController.h"
#import "Reachability.h"

@interface MenuViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (strong, nonatomic) NSData *dataJSON;

@property (strong, nonatomic) NSMutableArray *itemNameForRow;
@property (strong, nonatomic) NSMutableArray *itemDetailForRow;
@property (strong, nonatomic) NSMutableArray *itemPriceForRow;
@property (strong, nonatomic) NSMutableArray *nameForSection;
@property (strong, nonatomic) NSMutableArray *detailForSection;
@property (strong, nonatomic) NSMutableArray *priceForSection;

@property (strong, nonatomic) NSString *restaurantID;
- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer;

@end
