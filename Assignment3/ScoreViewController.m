//
//  ScoreViewController.m
//  Assignment3
//
//  Created by david on 11/22/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()
#pragma mark - Core Data managedObjectContext
- (NSManagedObjectContext*) managedObjectContext;

#pragma mark - Utilities Methods
-(BOOL) validateDataInput;

#pragma mark - UI Properties
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UITextField *hScore;
@property (weak, nonatomic) IBOutlet UITextField *mScore;
@property (weak, nonatomic) IBOutlet UITextField *fScore;
@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.courseScore) {
        // Create Save Button
        UIBarButtonItem *save = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(SaveScoreButton)];
        
        self.navigationItem.rightBarButtonItem = save;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Score", [self.courseScore valueForKeyPath:@"course.courseName"]];
        // We populate the view with the Model data passed to us
        self.hScore.text = [NSString stringWithFormat:@"%@", [self.courseScore valueForKey:@"hScore"]];
        self.mScore.text = [NSString stringWithFormat:@"%@", [self.courseScore valueForKey:@"mScore"]];
        self.fScore.text = [NSString stringWithFormat:@"%@", [self.courseScore valueForKey:@"fScore"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utilities Methods
-(BOOL) validateDataInput {
    // Close the keyboard
    [self.hScore resignFirstResponder];
    [self.mScore resignFirstResponder];
    [self.fScore resignFirstResponder];
    self.labelError.text = nil;
    
    float hScore = [self.hScore.text floatValue];
    float mScore = [self.mScore.text floatValue];
    float fScore = [self.fScore.text floatValue];
    
    if (hScore > 100) {
        self.labelError.text = @"Average homework cannot exceed 100";
        [self.hScore becomeFirstResponder];
        return NO;
    }
    if (mScore > 100) {
        self.labelError.text = @"Midterm cannot exceed 100";
        [self.mScore becomeFirstResponder];
        return NO;
    }
    if (fScore > 100) {
        self.labelError.text = @"Final cannot exceed 100";
        [self.fScore becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(void) SaveScoreButton {
    if (self.validateDataInput) {
        // Retrieve name and weights
        NSNumber* hScore = [NSNumber numberWithFloat:[self.hScore.text floatValue]];
        NSNumber* mScore = [NSNumber numberWithFloat:[self.mScore.text floatValue]];
        NSNumber* fScore = [NSNumber numberWithFloat:[self.fScore.text floatValue]];
        
        /* Get Context */
        NSManagedObjectContext* context = self.managedObjectContext;
        NSError* error = nil;
        
        // We are updating an existing one
        [self.courseScore setValue:hScore forKey: @"hScore"];
        [self.courseScore setValue:mScore forKey: @"mScore"];
        [self.courseScore setValue:fScore forKey: @"fScore"];
        
        /* Save it */
        if (! [context save:&error]) {
            NSLog(@"Failed to save score: %@\n", error);
        }
        
        /* Go back to the previous page */
        [self.navigationController popViewControllerAnimated:YES];

    }
}

#pragma mark - Core Data managedObjectContext
- (NSManagedObjectContext*) managedObjectContext {
    NSManagedObjectContext* context = nil;
    id app = [[UIApplication sharedApplication] delegate];
    if ([app performSelector:@selector(managedObjectContext)]) {
        context = [app managedObjectContext];
    }
    return context;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
