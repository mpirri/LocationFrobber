//
//  LFTraceTableViewController.m
//  LocationFrobber
//
//  Created by Mark Pirri on 8/21/12.
//  Copyright (c) 2012 Mark Pirri. All rights reserved.
//

#import "LFTraceTableViewController.h"

#import "LFLocationTraceManager.h"

@interface LFTraceTableViewController ()

@end

@implementation LFTraceTableViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBarButtonItems];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[LFLocationTraceManager sharedInstance] locationTrace] timeRecords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDate *time = [[[[LFLocationTraceManager sharedInstance] locationTrace] timeRecords] objectAtIndex:indexPath.row];
    NSArray *locationTraces = [[[LFLocationTraceManager sharedInstance] locationTrace] tracesForTime:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    NSString *textStr = [dateFormatter stringFromDate:time];
    
    if ([locationTraces count] > 1) {
        CLLocation *firstLocation = [locationTraces objectAtIndex:0];
        CLLocation *lastLocation = [locationTraces objectAtIndex:[locationTraces count] - 1];
        CLLocationDistance distanceTraveledMetric = [lastLocation distanceFromLocation:firstLocation];
        CLLocationDistance distanceTraveledAmerican = distanceTraveledMetric * 3.28084f;
        textStr = [textStr stringByAppendingFormat:@" (%.1f ft)",floor(distanceTraveledAmerican)];
    }
    
    cell.textLabel.text = textStr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d updates",[locationTraces count]];
    
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
}


#pragma mark - change notifications

- (void)locationTraceAddedNotification:(NSNotification *)inNotification
{
    [self.tableView reloadData];
}


#pragma mark - bar button items

- (void)startLogging
{
    [[LFLocationTraceManager sharedInstance] startLoggingLocation];
    [self updateBarButtonItems];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(locationTraceAddedNotification:)
     name:[[[LFLocationTraceManager sharedInstance] locationTrace] locationAddedNotificationName]
     object:nil];
}

- (void)stopLogging
{
    [[LFLocationTraceManager sharedInstance] stopLoggingLocation];
    [self updateBarButtonItems];
}

- (void)exportLog
{
    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
    composeViewController.mailComposeDelegate = self;
    [composeViewController setMessageBody:[[[LFLocationTraceManager sharedInstance] locationTrace] prettyTextWhatForMailingToMyBoss]
                                   isHTML:NO];
    [self.navigationController presentModalViewController:composeViewController animated:YES];
}

- (void)updateBarButtonItems
{
    if ([[LFLocationTraceManager sharedInstance] isLoggingLocation]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopLogging)];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startLogging)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(exportLog)];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

@end
