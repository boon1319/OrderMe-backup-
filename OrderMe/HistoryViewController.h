//
//  HistoryViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/14/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "SingletonClass.h"

@interface HistoryViewController : UITableViewController <UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    sqlite3 *orderDB;
}

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (strong, nonatomic) NSString *databasePath;

@property (strong, nonatomic) NSMutableArray *oldOrderArray;
@property (strong, nonatomic) NSMutableArray *itemForSection;

- (IBAction)clearHistory:(id)sender;

- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer;

@end
