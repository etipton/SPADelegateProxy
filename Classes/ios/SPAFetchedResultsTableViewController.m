//
//  SPAFetchedResultsTableViewController.m
//  Spectappular
//
//  Created by Eric Tipton on 1/30/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import "SPAFetchedResultsTableViewController.h"
#import "SPAFetchedResultsTableDelegate.h"

@interface SPAFetchedResultsTableViewController ()

@property SPAFetchedResultsTableDelegate *fetchedResultsTableDelegate;
- (NSString *)cellIdentifier;

@end

@implementation SPAFetchedResultsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.managedObjectContext = [(id)UIApplication.sharedApplication.delegate managedObjectContext];
    self.fetchedResultsTableDelegate = [SPAFetchedResultsTableDelegate delegateWithViewController:self
        cellIdentifier:self.cellIdentifier];
}

- (NSString *)cellIdentifier
{
    return @"Cell"; // subclasses should override this
}

// If these aren't defined here, the fetchedResultsTableDelegate (proxy) will use the default UITableViewController
// methods and ignore the desired methods defined by SPAFetchedResultsTableDelegate

// UITableViewDelegate, UITableViewDataSource protocol methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsTableDelegate numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsTableDelegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsTableDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
