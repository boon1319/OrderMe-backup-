//
//  RestaurantViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/13/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "RestaurantViewController.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopMusic) name:@"Sound is off" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusic) name:@"Sound is on" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.singletonObj = [SingletonClass sharedInstance];
    
    // Refreshing the table manually
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // Play or Stop Theme sound based on user's setting
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    BOOL enabled = [defaults boolForKey:@"sound_preference"];
    if (enabled == YES)
    {
//        [NSThread detachNewThreadSelector:@selector(playMusic) toTarget:self withObject:nil];
        [self playMusic];
    }
}

- (void)refreshTable
{
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];
}

- (void)updateTable
{
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}

- (void)playMusic
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *themeNumber = [defaults valueForKey:@"tone_preference"];
    int num = [themeNumber intValue] + 1;
    NSString *themeName = [NSString stringWithFormat:@"Theme%i",num];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:themeName ofType:@"mp3"];
    NSURL* soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.audioPlayer.numberOfLoops=-1;
    [self.audioPlayer play];
}

- (void)stopMusic
{
    [self.audioPlayer stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.singletonObj.nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.singletonObj.nameArray objectAtIndex:indexPath.row]];
    
    float R = (arc4random()%300);
    float G = (arc4random()%300);
    float B = (arc4random()%300);
    R = R/300;
    G = G/300;
    B = B/300;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    UIView * myBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    UIColor * myColor = [UIColor colorWithRed:R green:G blue:B alpha:.2];
    myBackgroundView.backgroundColor = myColor;
    cell.backgroundView = myBackgroundView;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *cellPath = [self.tableView indexPathForSelectedRow];
    
    if([segue.identifier isEqualToString:@"MenuSegue"])
    {
        MenuViewController *menuView = [segue destinationViewController];
        
        menuView.restaurantID = [self.singletonObj.idArray objectAtIndex:cellPath.row];
        self.singletonObj.restaurantID = [self.singletonObj.idArray objectAtIndex:cellPath.row];
        self.singletonObj.restaurantName = [self.singletonObj.nameArray objectAtIndex:cellPath.row];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
