//
//  MenuViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/11/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.singletonObj = [SingletonClass sharedInstance];
    
    self.singletonObj.gblTypeArray = [[NSMutableArray alloc] init];
    
    self.nameForSection = [[NSMutableArray alloc] init];
    self.detailForSection = [[NSMutableArray alloc] init];
    self.priceForSection = [[NSMutableArray alloc] init];
    
    // Detect Swipe Gesture
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    /////////////////////////////////////////////////
    ///////// Check for Internet connection /////////
    /////////////////////////////////////////////////
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        UIAlertView *errorView;
        
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"http://api.allmenus.com/restaurant?type=menu&restaurant_id=%@&v=2&api_key=v8cyc2vubuskc25qb835khg7&return_type=json",self.restaurantID];
    
        NSURL *JSONURL = [NSURL URLWithString:urlString];
    
        self.dataJSON = [NSData dataWithContentsOfURL:JSONURL];
        [self dataRetreived:self.dataJSON];
    }
    
    // Refreshing the table manually
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
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

- (void)dataRetreived:(NSData*)dataResponse
{
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:0 error:&error];
    
    NSDictionary *menu = [jsonResponse objectForKey:@"menu"];
    
    NSArray *group = [menu objectForKey:@"groups"];
    
    NSDictionary *main = [group objectAtIndex:0];
    
    NSArray *category = [main objectForKey:@"categories"];
    
    NSLog(@"No of categories = %i", [category count]);
    
    for (int i = 0; i < [category count]; i++)
    {
        NSString *type = [[category objectAtIndex:i] objectForKey:@"name"];
        NSLog(@"%@", type);
        
        [self.singletonObj.gblTypeArray addObject:type];
        
        NSArray *item = [[category objectAtIndex:i] objectForKey:@"items"];
        
        NSLog(@"No of items = %i", [item count]);
        
        self.itemNameForRow = [[NSMutableArray alloc] init];
        self.itemDetailForRow = [[NSMutableArray alloc] init];
        self.itemPriceForRow = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < [item count]; j++) {
            NSString *itemName = [[item objectAtIndex:j] objectForKey:@"name"];
//            NSLog(@"%@", itemName);
            
            NSString *itemDescription = [[item objectAtIndex:j] objectForKey:@"description"];
            if ([itemDescription isEqualToString:@" "]) {
                itemDescription = @"N/A";
            }
//            NSLog(@"%@", itemDescription);
            NSString *meatAndPrice = [[NSString alloc] init];
            
            NSArray *size = [[item objectAtIndex:j] objectForKey:@"sizes"];
            if ([size count] == 1)
            {
                meatAndPrice = [NSString stringWithFormat:@"$%@",[[size objectAtIndex:0] objectForKey:@"price"]];

                if ([meatAndPrice isEqualToString:@"$"]) {
                    meatAndPrice = @"N/A";
                }
            }else{
                for (int k = 0; k < [size count]; k++)
                {
                    NSString *meat = [[size objectAtIndex:k] objectForKey:@"name"];

                    NSString *price = [NSString stringWithFormat:@"$%@",[[size objectAtIndex:k] objectForKey:@"price"]];

                    if ([price isEqualToString:@"$"]) {
                    price = @"N/A";
                    }
                    meatAndPrice = [meatAndPrice stringByAppendingFormat:@"%@ %@ ",meat,price];
                }
            }
//            NSLog(@"%@", meatAndPrice);
            [self.itemNameForRow addObject:itemName];
            [self.itemDetailForRow addObject:itemDescription];
            [self.itemPriceForRow addObject:meatAndPrice];
        }
        NSDictionary *itemNameForSection = [NSDictionary dictionaryWithObject:self.itemNameForRow forKey:@"name"];

        [self.nameForSection addObject:itemNameForSection];
        NSDictionary *itemDetailForSection = [NSDictionary dictionaryWithObject:self.itemDetailForRow forKey:@"detail"];

        [self.detailForSection addObject:itemDetailForSection];
        NSDictionary *itemPriceForSection = [NSDictionary dictionaryWithObject:self.itemPriceForRow forKey:@"price"];

        [self.priceForSection addObject:itemPriceForSection];
    }
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
    return [self.singletonObj.gblTypeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSDictionary *dictionary = [self.nameForSection objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"name"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    for (int i = 0; i < [self.singletonObj.gblTypeArray count]; i++) {
        if (section == i) {
            return [self.singletonObj.gblTypeArray objectAtIndex:i];
        }
    }
//    if (section == 0){
//        return [self.singletonObj.gblTypeArray objectAtIndex:0];
//    }else if (section == 1){
//        return [self.singletonObj.gblTypeArray objectAtIndex:1];
//    }else if (section == 2){
//        return [self.singletonObj.gblTypeArray objectAtIndex:2];
//    }else if (section == 3){
//        return [self.singletonObj.gblTypeArray objectAtIndex:3];
//    }else if (section == 4){
//        return [self.singletonObj.gblTypeArray objectAtIndex:4];
//    }else if (section == 5){
//        return [self.singletonObj.gblTypeArray objectAtIndex:5];
//    }else if (section == 6){
//        return [self.singletonObj.gblTypeArray objectAtIndex:6];
//    }else if (section == 7){
//        return [self.singletonObj.gblTypeArray objectAtIndex:7];
//    }else if (section == 8){
//        return [self.singletonObj.gblTypeArray objectAtIndex:8];
//    }else if (section == 9){
//        return [self.singletonObj.gblTypeArray objectAtIndex:9];
//    }else if (section == 10){
//        return [self.singletonObj.gblTypeArray objectAtIndex:10];
//    }else if (section == 11){
//        return [self.singletonObj.gblTypeArray objectAtIndex:11];
//    }else if (section == 12){
//        return [self.singletonObj.gblTypeArray objectAtIndex:12];
//    }else if (section == 13){
//        return [self.singletonObj.gblTypeArray objectAtIndex:13];
//    }else if (section == 14){
//        return [self.singletonObj.gblTypeArray objectAtIndex:14];
//    }else if (section == 15){
//        return [self.singletonObj.gblTypeArray objectAtIndex:15];
//    }else if (section == 16){
//        return [self.singletonObj.gblTypeArray objectAtIndex:16];
//    }else if (section == 17){
//        return [self.singletonObj.gblTypeArray objectAtIndex:17];
//    }else if (section == 18){
//        return [self.singletonObj.gblTypeArray objectAtIndex:18];
//    }else if (section == 19){
//        return [self.singletonObj.gblTypeArray objectAtIndex:19];
//    }else if (section == 20){
//        return [self.singletonObj.gblTypeArray objectAtIndex:20];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *nameDictionary = [self.nameForSection objectAtIndex:indexPath.section];
    NSArray *nameArray = [nameDictionary objectForKey:@"name"];
    NSString *cellNameValue = [nameArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellNameValue;
    
    NSDictionary *priceDictionary = [self.priceForSection objectAtIndex:indexPath.section];
    NSArray *priceArray = [priceDictionary objectForKey:@"price"];
    NSString *cellPriceValue = [priceArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = cellPriceValue;
    
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
    
    if([segue.identifier isEqualToString:@"DetailSegue"])
    {
        NSDictionary *nameDictionary = [self.nameForSection objectAtIndex:cellPath.section];
        NSArray *nameArray = [nameDictionary objectForKey:@"name"];
        NSString *cellNameValue = [nameArray objectAtIndex:cellPath.row];
        
        NSDictionary *detailDictionary = [self.detailForSection objectAtIndex:cellPath.section];
        NSArray *detailArray = [detailDictionary objectForKey:@"detail"];
        NSString *cellDetailValue = [detailArray objectAtIndex:cellPath.row];
        
        NSDictionary *priceDictionary = [self.priceForSection objectAtIndex:cellPath.section];
        NSArray *priceArray = [priceDictionary objectForKey:@"price"];
        NSString *cellPriceValue = [priceArray objectAtIndex:cellPath.row];
        
        ItemDetailViewController *displayView = [segue destinationViewController];
        [displayView setTitle:cellNameValue];
        displayView.name = cellNameValue;
        displayView.detail = cellDetailValue;
        displayView.price = cellPriceValue;
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

- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
