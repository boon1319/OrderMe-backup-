//
//  ItemDetailViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/11/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"

@interface ItemDetailViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDetailLabel;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *price;

- (IBAction)addOrderToCart:(id)sender;
- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer;

@end
