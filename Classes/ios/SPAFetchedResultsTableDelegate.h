//
//  SPAFetchedResultsTableDelegate.h
//  Spectappular
//
//  Created by Eric Tipton on 1/28/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPADelegate.h"

@protocol SPAFetchedResultsTableOwner

- (NSFetchedResultsController *)fetchedResultsController;
- (UITableView *)tableView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

// Conforms to UITableViewDataSource, UITableViewDelegate, and NSFetchedResultsControllerDelegate protocols
// NOTE: The viewController must conform to the SPAFetchedResultsTableOwner protocol above
@interface SPAFetchedResultsTableDelegate : SPADelegate <UITableViewDataSource, UITableViewDelegate,
    NSFetchedResultsControllerDelegate>

+ (id)delegateWithViewController:(UIViewController *)viewController cellIdentifier:(NSString *)cellIdentifier;

@end
