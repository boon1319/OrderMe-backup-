//
//  RestaurantViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/13/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
#import "MenuViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RestaurantViewController : UITableViewController

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@end
