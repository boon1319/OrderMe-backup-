//
//  CartViewController.m
//  OrderMe
//
//  Created by Unbounded Solutions on 5/13/13.
//  Copyright (c) 2013 Unbounded Solutions. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.singletonObj.badgeCount = @"0";
    [[self.tabBarController.viewControllers objectAtIndex:2]tabBarItem].badgeValue = nil;
    
    [self.tableView reloadData];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    self.singletonObj.badgeCount = @"0";
    [[self.tabBarController.viewControllers objectAtIndex:2]tabBarItem].badgeValue = nil;
    [self.tableView reloadData];
}

- (void)insertIntoDatabase:(NSString *)restname :(NSString *)date :(NSString *)name
{
    sqlite3_stmt *statement = NULL;
    
    const char *dbPath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &orderDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ORDERS (restname, date, name) VALUES (\"%@\", \"%@\", \"%@\")", restname, date, name];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(orderDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", @"New Order Added");
        }else{
            NSLog(@"%@", @"Failed to add new order");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(orderDB);
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
                NSString *restaurantName = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                NSString *date = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString *orderName = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSArray *oldOrder = [[NSArray alloc] initWithObjects:restaurantName, date, orderName, nil];
                [self.singletonObj.gblOldOrderArray addObject:oldOrder];
                NSLog(@"%@", oldOrder);
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.singletonObj.gblNewOrderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.singletonObj.gblNewOrderArray objectAtIndex:indexPath.row];
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.singletonObj.gblNewOrderArray removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

- (IBAction)openMail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString *subject = [NSString stringWithFormat:@"%@ To Go Order", self.singletonObj.restaurantName];
        [mailer setSubject:subject];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"boon1319@gmail.com", nil];
        [mailer setToRecipients:toRecipients];
        UIImage *myImage = [UIImage imageNamed:@"unbounded.jpeg"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"unboundedImage"];
        NSString *emailBody = [[NSString alloc] init];
        for (int i = 0; i < [self.singletonObj.gblNewOrderArray count]; i++) {
            emailBody = [emailBody stringByAppendingFormat:@"%@\n", [self.singletonObj.gblNewOrderArray objectAtIndex:i]];
        }
        [mailer setMessageBody:emailBody isHTML:NO];
//        [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)swipeLeftDetected:(UISwipeGestureRecognizer *)recognizer {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete Cart" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.singletonObj.gblNewOrderArray removeAllObjects];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }

    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your cart is empty" message:@"Please choose new items." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    if (result == MFMailComposeResultSent)
    {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        DateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.singletonObj.orderDate = [DateFormatter stringFromDate:[NSDate date]];
        NSLog(@"%@",self.singletonObj.restaurantName);
        NSLog(@"%@",self.singletonObj.orderDate);
        for (int i = 0; i < [self.singletonObj.gblNewOrderArray count]; i++) {
            [self insertIntoDatabase:self.singletonObj.restaurantName :self.singletonObj.orderDate :[self.singletonObj.gblNewOrderArray objectAtIndex:i]];
        }
    
        [self.singletonObj.gblNewOrderArray removeAllObjects];
        [self.tableView reloadData];
    }
    // Remove the mail view
    
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
