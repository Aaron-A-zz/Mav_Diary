//
//  MavNewEntryViewController.m
//  Diary
//
//  Created by Mav3r1ck on 5/25/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

#import "MavEntryViewController.h"
#import "MavDiaryEntry.h"
#import "MavCoreDataStack.h"


@interface MavEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MavEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.entry != nil) {
        self.textField.text = self.entry.body;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)insertDiaryEntry {
    MavCoreDataStack *coreDataStack = [MavCoreDataStack defaultStack];
    MavDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"MavDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textField.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
}

-(void)updateDiaryEntry {
    self.entry.body = self.textField.text;
    
    MavCoreDataStack *coreDataStack = [MavCoreDataStack defaultStack];
    [coreDataStack saveContext];
    
}

- (IBAction)doneWasPressed:(id)sender {
    if (self.entry !=nil) {
        [self updateDiaryEntry];
    }else {
         [self insertDiaryEntry];
    }
    [self dismissSelf];
    
}


- (IBAction)cancelWashPressed:(id)sender {

        [self dismissSelf];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
