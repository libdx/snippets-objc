//
//  DetailViewController.m
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/18/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import "DetailViewController.h"
#import "TableViewModelManager.h"
#import "TableViewModels.h"
#import "TableViewModelObjects.h"
#import "UITableViewCell+TableViewModel.h"
#import "NSManagedObject+TableViewModel.h"

@interface DetailViewController ()
@property (strong, nonatomic) TableViewModel *tableViewModel;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void)configureView;
@end

@implementation DetailViewController

// TODO: assign model objects to TableViewModel
- (TableViewModel *)tableViewModel
{
    if (nil == _tableViewModel) {
        _tableViewModel = [[TableViewModelManager sharedManager] detailedTableViewModel];
        [_tableViewModel eachRow:^(TableViewRow *row) {
            row.didSelectCallback = ^ {
                NSLog(@"did select from block");
            };
        }];
    }
    return _tableViewModel;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil == _fetchedResultsController) {

        (void)self.tableViewModel;

        NSFetchRequest *r = [NSFetchRequest fetchRequestWithEntityName:@"TableViewRow"];
        r.predicate = [NSPredicate predicateWithFormat:@"section.table.identifier = %@", DetailedTableViewModelID];
        r.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"section.position" ascending:YES],
                              [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
        NSManagedObjectContext *ctx = [TableViewModelManager sharedManager].managedObjectContext;
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:r managedObjectContext:ctx sectionNameKeyPath:@"section.position" cacheName:nil];
        [_fetchedResultsController performFetch:nil];
    }
    return _fetchedResultsController;
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // put to NSFetchedResultsController's category -cellForIndexPath
    TableViewRow *row = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
    [cell updateWithObject:row.boundObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    void (^callback)() = [[self.fetchedResultsController objectAtIndexPath:indexPath] didSelectCallback];
    if (callback)
        callback();
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


@end
