//
//  MavEntryListViewController.m
//  Diary
//
//  Created by Mav3r1ck on 5/25/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

#import "MavEntryListViewController.h"
#import "MavCoreDataStack.h"
#import "MavDiaryEntry.h"
#import "MavEntryViewController.h"

@interface MavEntryListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResualtsController;

@end

@implementation MavEntryListViewController

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
    
    [self.fetchedResualtsController performFetch:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        MavEntryViewController *entryViewController = ( MavEntryViewController *) navigationController.topViewController;
        entryViewController.entry = [self.fetchedResualtsController objectAtIndexPath:indexPath];
        
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
    return self.fetchedResualtsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResualtsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    MavDiaryEntry *entry = [self.fetchedResualtsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entry.body;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MavDiaryEntry *entry = [self.fetchedResualtsController objectAtIndexPath:indexPath];
    MavCoreDataStack *coreDataStack = [MavCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResualtsController sections][section];
    return [sectionInfo name];
}


-(NSFetchRequest *)entryListFetchRequest {
    NSFetchRequest *festchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MavDiaryEntry"];
    
    festchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return festchRequest;
}


-(NSFetchedResultsController *)fetchedResualtsController {
    if (_fetchedResualtsController !=nil) {
        return _fetchedResualtsController;
    }
    MavCoreDataStack *coreDataStack = [MavCoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    _fetchedResualtsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResualtsController.delegate = self;
    
    return _fetchedResualtsController;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
            case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
}



@end
