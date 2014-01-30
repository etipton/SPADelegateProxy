//
//  SPATableDelegate.m
//  Spectappular
//
//  Created by Eric Tipton on 1/28/14.
//  Copyright (c) 2014 Eric Tipton. All rights reserved.
//

#import "SPAFetchedResultsTableDelegate.h"
#import "SPADelegateProxy.h"

@interface SPAFetchedResultsTableDelegate ()

@property (weak) UIViewController<SPAFetchedResultsTableOwner> *viewController;
@property UITableView *tableView;
@property NSFetchedResultsController *fetchedResultsController;
@property NSString *cellIdentifier;

- (id)initWithViewController:(UIViewController *)viewController cellIdentifier:(NSString *)cellIdentifier;

@end

@implementation SPAFetchedResultsTableDelegate

+ (id)delegateWithViewController:(UIViewController *)viewController cellIdentifier:(NSString *)cellIdentifier
{
    return [[self alloc] initWithViewController:viewController cellIdentifier:cellIdentifier];
}

- (id)initWithViewController:(UIViewController<SPAFetchedResultsTableOwner> *)viewController
    cellIdentifier:(NSString *)cellIdentifier
{
    id proxy = [super initWithOverrider:viewController];
    self = [proxy targetDelegate];
    if (self) {
        _viewController = viewController;
        _tableView = viewController.tableView;
        _fetchedResultsController = viewController.fetchedResultsController;
        _cellIdentifier = cellIdentifier;

        _tableView.delegate = proxy;
        _tableView.dataSource = proxy;
        _fetchedResultsController.delegate = proxy;
    }
    return proxy;
}

// UITableViewDelegate, UITableViewDataSource protocol methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    [self.viewController configureCell:cell atIndexPath:indexPath];
    return cell;
}

// NSFetchedControllerDelegate protocol methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.viewController configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
