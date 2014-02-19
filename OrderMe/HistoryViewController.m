//
//  HistoryViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/14/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

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
    
    self.singletonObj = [SingletonClass sharedInstance];
    
    // Detect Swipe Gesture
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    ///////////////////////////////////////////////////////
    ////////////          DATABASE           //////////////
    ///////////////////////////////////////////////////////
    
    NSString *docsDirectory;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDirectory = [dirPaths objectAtIndex:0];

    self.databasePath = [[NSString alloc] initWithString:[docsDirectory stringByAppendingPathComponent:@"orderDB.db"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.databasePath] == NO)
    {
        const char *dbPath = [self.databasePath UTF8String];
        
        if (sqlite3_open(dbPath, &orderDB) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ORDERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, RESTNAME TEXT, DATE TEXT, NAME TEXT)";
            if (sqlite3_exec(orderDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"%@", @"Failed to create table");
            }sqlite3_close(orderDB);
        }else{
            NSLog(@"%@", @"Failed to open/close database");
        }
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateTable];
}

- (void)updateTable
{
    self.oldOrderArray = [[NSMutableArray alloc] init];
    [self loadFromDatabase];
    self.itemForSection = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.singletonObj.nameArray count]; i++) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        NSString *restaurantTemp = [self.singletonObj.nameArray objectAtIndex:i];
        
        for (int j = 0; j < [self.oldOrderArray count]; j++) {
            
            NSDictionary *itemDict = [self.oldOrderArray objectAtIndex:j];
            NSString *name = [itemDict objectForKey:@"restaurant"];
            if ([name isEqualToString:restaurantTemp]) {
                [tempArray addObject:itemDict];
            }
        }
        [self.itemForSection addObject:tempArray];
    }
    
    [self.tableView reloadData];
}

- (void)deleteFromDatabase:(NSString *)restname :(NSString *)date :(NSString *)name
{
    sqlite3_stmt *statement = NULL;
    
    const char *dbPath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &orderDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM ORDERS WHERE restname = \"%@\" AND date = \"%@\" AND name = \"%@\"", restname, date, name];
        const char *delete_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(orderDB, delete_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", @"Order Deleted");
        }else{
            NSLog(@"%@", @"Failed to delete order");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(orderDB);
}

- (void)loadFromDatabase
{
    sqlite3_stmt *statement = NULL;
    
    const char *dbPath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &orderDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ORDERS"];
        
        const char *check_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(orderDB, check_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *restaurantName = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString *date = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *orderName = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSDictionary *oldOrder = [NSDictionary dictionaryWithObjectsAndKeys:restaurantName,@"restaurant",orderName,@"item",date,@"date", nil];
                [self.oldOrderArray addObject:oldOrder];
                NSLog(@"%@", @"Match Found");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(orderDB);
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
    if ([self.itemForSection count] > 0) {
        // Return the number of sections.
        return [self.itemForSection count];
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.itemForSection count] > 0) {
        // Return the number of rows in the section.
        NSArray *array = [self.itemForSection objectAtIndex:section];
        return [array count];
    }else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.singletonObj.nameArray count] != 0) {
        for (int i = 0; i < [self.singletonObj.nameArray count]; i++) {
            if (section == i)
            {
                return [self.singletonObj.nameArray objectAtIndex:i];
            }
        }
    }else{
        return @"";
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if ([self.singletonObj.nameArray count] != 0) {
//        for (int i = 0; i < [self.singletonObj.nameArray count]; i++) {
//            if (section == i)
//            {
//                return [self.singletonObj.nameArray objectAtIndex:i];
//            }
//        }
//    }else{
//        return @"";
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSArray *cellArray = [self.itemForSection objectAtIndex:indexPath.section];
    NSDictionary *cellDict = [cellArray objectAtIndex:indexPath.row];
    NSString *itemName = [cellDict objectForKey:@"item"];
    NSString *date = [cellDict objectForKey:@"date"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", itemName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",date];
    
    return cell;
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

- (IBAction)clearHistory:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete History" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete History" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self resetDatabase];
            break;
            
        default:
            break;
    }
    
    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your history is empty" message:@"Please place a new order" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)resetDatabase
{
    sqlite3_stmt *statement = NULL;
    
    const char *dbPath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &orderDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM ORDERS"];
        const char *delete_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(orderDB, delete_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", @"All Orders Deleted");
        }else{
            NSLog(@"%@", @"Failed to reset Database");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(orderDB);
    [self updateTable];
}

@end
