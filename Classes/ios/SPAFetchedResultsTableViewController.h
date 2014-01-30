//
//  SPAFetchedResultsTableViewController.h
//  Reeyup
//
//  Created by Eric Tipton on 1/30/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import <UIKit/UIKit.h>

// Designed to be a drop-in replacement for UITableViewController for controllers that utilize fetchedResultsControllers
//
// Makes the following assumptions:
//
// 1. The Application Delegate has a managedObjectContext property (self.managedObjectContext will point to it)
// 2. Subclasses will contain a fetchedResultsController property (may utilize the self.managedObjectContext
//    property to define).
// 3. Subclasses will implement the method: - (NSString *)cellIdentifier; the default return value is @"Cell"
//
@interface SPAFetchedResultsTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
