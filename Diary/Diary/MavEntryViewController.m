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


@interface MavEntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic, strong) UIImage *pickedImage;

@property (nonatomic, assign) enum MavDiaryEntryMood pickedMood;

@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

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
    
    NSDate *date;
    
    // Do any additional setup after loading the view.
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedMood = MavDiaryEntryMoodGood;
        date = [NSDate date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLable.text = [dateFormatter stringFromDate:date];
    
    self.textView.inputAccessoryView = self.accessoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
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
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    [coreDataStack saveContext];
    
}

-(void)updateDiaryEntry {
    self.entry.body = self.textView.text;
    
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    
    MavCoreDataStack *coreDataStack = [MavCoreDataStack defaultStack];
    [coreDataStack saveContext];
    
}

-(void)promptForSource {
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:@"ImageSource" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

-(void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info [UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setPickedMood:(enum MavDiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5;
    self.averageButton.alpha = 0.5;
    
    switch (pickedMood) {
        case MavDiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case MavDiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
        case MavDiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
    }
}


-(void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"]forState:UIControlStateNormal];
         } else {
         [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
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

- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = MavDiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = MavDiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = MavDiaryEntryMoodGood;
}
- (IBAction)imageButtonWasPressed:(id)sender {
    
}
- (IBAction)imageSelectionButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}



@end
