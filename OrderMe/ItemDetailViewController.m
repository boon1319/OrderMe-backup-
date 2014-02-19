//
//  ItemDetailViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/11/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

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
    
    // Detect Swipe Gesture
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    NSLog(@"%f,%f",self.detailScrollView.frame.size.width, self.detailScrollView.frame.size.height);
    
    // code for Portrait orientation
    self.detailScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.jpg"]]];
        
	// Do any additional setup after loading the view.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        // code for landscape orientation
        self.detailScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background_rotate.jpg"]]];
    }
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        // code for Portrait orientation
        self.detailScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.jpg"]]];
    }
}

- (void)addTextLabelToScrollView
{
    self.itemNameLabel.text = self.name;
    [self.detailScrollView addSubview:self.itemNameLabel];
    NSString *temp = [self.detail stringByAppendingFormat:@"\n\n%@",self.price];
    self.itemDetailLabel.text = temp;
    [self.detailScrollView addSubview:self.itemDetailLabel];
    [self.detailScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 400)];
    
    self.detailScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.jpeg"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addOrderToCart:(id)sender {
    [self.singletonObj.gblNewOrderArray addObject:self.name];
    
    if (self.singletonObj.badgeCount == nil)
    {
        self.singletonObj.badgeCount = @"0";
    }else{
        int counter = [self.singletonObj.badgeCount intValue];
        counter++;
        self.singletonObj.badgeCount = [NSString stringWithFormat:@"%d", counter];
        [[self.tabBarController.viewControllers objectAtIndex:2]tabBarItem].badgeValue = self.singletonObj.badgeCount;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
