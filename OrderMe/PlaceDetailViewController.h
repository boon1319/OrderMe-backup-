//
//  PlaceDetailViewController.h
//  OrderMe
//
//  Created by Unbounded Solutions on 5/14/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "SingletonClass.h"

@interface PlaceDetailViewController : UIViewController

@property (strong, nonatomic) SingletonClass *singletonObj;

@property (weak, nonatomic) IBOutlet UIScrollView *placeScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *placeAddress;
@property (strong, nonatomic) NSString *placePhone;
@property (strong, nonatomic) NSString *imageName;

@property (weak, nonatomic) SLComposeViewController *composeController;

- (IBAction)CallToRestaurant:(id)sender;

- (IBAction)shareOnFacebook:(id)sender;

- (IBAction)returnToMap:(id)sender;

@end
