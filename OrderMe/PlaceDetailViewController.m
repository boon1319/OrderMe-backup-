//
//  PlaceDetailViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/14/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "PlaceDetailViewController.h"

@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.singletonObj = [SingletonClass sharedInstance];

    [self addTextLabelToScrollView];
    
    // code for Portrait orientation
    self.placeScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.jpg"]]];
	// Do any additional setup after loading the view.
}

- (void)addTextLabelToScrollView
{
    for (int i = 0; i < [self.singletonObj.nameArray count]; i++) {
        NSString *tempStr = [self.singletonObj.nameArray objectAtIndex:i];
        if ([self.placeName isEqualToString:tempStr])
        {
            self.imageName = [NSString stringWithFormat:@"%@",[self.singletonObj.imageArray objectAtIndex:i]];
            UIImage *image = [UIImage imageNamed:self.imageName];
            self.imageView.clipsToBounds = YES;
            self.imageView.image = image;
            self.imageView.contentMode = UIViewContentModeScaleToFill;
        }
    }
    [self.placeScrollView addSubview:self.imageView];
    self.nameLabel.text = self.placeName;
    [self.placeScrollView addSubview:self.nameLabel];
    self.addressLabel.text = [NSString stringWithFormat:@"Address: %@",self.placeAddress];
    [self.placeScrollView addSubview:self.addressLabel];
    self.phoneLabel.text = [NSString stringWithFormat:@"Tel: %@",self.placePhone];
    [self.placeScrollView addSubview:self.phoneLabel];
    [self.placeScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 400)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CallToRestaurant:(id)sender {

    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:1%@",self.placePhone];
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/. ()-"];
    phoneStr = [[phoneStr componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSLog(@"Calling %@",phoneStr);
    NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:phoneURL])
    {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)shareOnFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Device is able to send a Facebook message
        self.composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        UIImage *postImage = [UIImage imageNamed:self.imageName];
        NSString *postText = [NSString stringWithFormat:@"Check this place out guys!! \"%@\" is awesome!!", self.placeName];
        
        [self.composeController setInitialText:postText];
        [self.composeController addImage:postImage];
        
        [self presentViewController:self.composeController animated:YES completion:nil];
    }
    [self.composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)returnToMap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
