//
//  CartViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/13/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
#import <MessageUI/MessageUI.h>
#import "sqlite3.h"

@interface CartViewController : UITableViewController <MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    sqlite3 *orderDB;
}

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (strong, nonatomic) NSString *databasePath;

- (IBAction)openMail:(id)sender;

- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer;

@end
