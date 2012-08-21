//
//  LFMasterViewController.h
//  LocationFrobber
//
//  Created by Mark Pirri on 8/21/12.
//  Copyright (c) 2012 Mark Pirri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFDetailViewController;

@interface LFMasterViewController : UITableViewController

@property (strong, nonatomic) LFDetailViewController *detailViewController;

@end
