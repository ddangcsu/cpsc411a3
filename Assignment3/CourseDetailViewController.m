//
//  CourseDetailViewController.m
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "EnrolledStudentsTableViewController.h"

@interface CourseDetailViewController ()
#pragma mark - UI Properties
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *hWeight;
@property (weak, nonatomic) IBOutlet UITextField *mWeight;
@property (weak, nonatomic) IBOutlet UITextField *fWeight;
@property (weak, nonatomic) IBOutlet UIButton *showEnrolledStudentsButton;
#pragma mark - UI Actions
- (IBAction)Cancel:(UIBarButtonItem *)sender;
- (IBAction)Save:(UIBarButtonItem *)sender;

#pragma mark - Utilities Methods
-(BOOL) validateDataInput;

#pragma mark - CoreData
-(NSManagedObjectContext*) managedObjectContext;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.aCourse) {
        // We have data passing in
        self.navigationItem.title = self.aCourse.courseName;
        self.courseName.text = self.aCourse.courseName;
        self.hWeight.text = [self.aCourse.hWeight stringValue];
        self.mWeight.text = [self.aCourse.mWeight stringValue];
        self.fWeight.text = [self.aCourse.fWeight stringValue];
        
        if (self.aCourse.students.count > 0) {
            self.showEnrolledStudentsButton.hidden = NO;
        } else {
            self.showEnrolledStudentsButton.hidden = YES;
        }
        
    } else {
        // We are doing a new add
        self.navigationItem.title = @"New Course";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CoreData retrieve managedObjectContext
-(NSManagedObjectContext*) managedObjectContext {
    NSManagedObjectContext* context = nil;
    id app = [[UIApplication sharedApplication]delegate];
    if ([app performSelector:@selector(managedObjectContext)]) {
        context = [app managedObjectContext];
    }
    return context;
}


#pragma mark - TextField Delegation
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.hWeight ||
        textField == self.mWeight ||
        textField == self.fWeight) {
        // We add the Button button toolbar onto the keypad
        [Utilities addDoneButtonToKeyPad:textField inView:self.view];
    }
    return YES;
}

-(BOOL) validateDataInput {
    
    // Hide keyboards
    [self.courseName resignFirstResponder];
    [self.hWeight resignFirstResponder];
    [self.mWeight resignFirstResponder];
    [self.fWeight resignFirstResponder];
    
    // Retrieve name and weights
    NSString *name = [[self.courseName.text uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float hWeight = (self.hWeight.text != nil) ? [self.hWeight.text floatValue]: 0;
    float mWeight = (self.mWeight.text != nil) ? [self.mWeight.text floatValue]: 0;
    float fWeight = (self.fWeight.text != nil) ? [self.fWeight.text floatValue]: 0;
    
    // Perform validations
    if (name.length <= 0) {
        self.labelError.text = @"Name is required";
        [self.courseName becomeFirstResponder];
        return NO;
    }
    if (hWeight < 0 || hWeight > 100) {
        self.labelError.text = @"Homework Weight valid range 0 - 100";
        [self.hWeight becomeFirstResponder];
        [self.hWeight setSelected:YES];
        return NO;
    }
    if (mWeight < 0 || mWeight > 100) {
        self.labelError.text = @"Midterm Weight valid range 0 - 100";
        [self.mWeight becomeFirstResponder];
        [self.mWeight setSelected:YES];
        return NO;
    }
    if (fWeight < 0 || fWeight > 100) {
        self.labelError.text = @"Final Weight valid range 0 - 100";
        [self.fWeight becomeFirstResponder];
        [self.fWeight setSelected:YES];
        return NO;
    }
    if ( (hWeight + mWeight + fWeight) != 100) {
        self.labelError.text = @"Sum Weights must added up to 100";
        return NO;
    }
    
    /* Check for uniqueness in database */
    if (! self.aCourse || ! [[self.aCourse valueForKey: @"courseName"] isEqualToString:name]) {
        // Build a condition
        NSPredicate* condition = [NSPredicate predicateWithFormat:@"courseName == %@", name];
        
        // Check Course data
        NSMutableArray* results = [Course fetchRowsWithPredicates:@[condition] inContext:self.managedObjectContext];
        
        if (results.count > 0) {
            self.labelError.text = @"Course name already exist !";
            [self.courseName becomeFirstResponder];
            [self.courseName setSelected:YES];
            return NO;
        }
    }
    
    // If we can get here it means we are good with validation
    self.labelError.text = nil;
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEnrolledStudents"]) {
        EnrolledStudentsTableViewController* enrolledStudentsVC = segue.destinationViewController;
        enrolledStudentsVC.enrolledStudents = [[self.aCourse.students allObjects] mutableCopy];
    }
}


#pragma mark - UI Actions
- (IBAction)Cancel:(UIBarButtonItem *)sender {
    // Get the View Controller that present this Course Detail Page
    UIViewController *presentFromVC = self.presentingViewController;
    NSLog(@"presentFromVC Class Name: %@\n", [presentFromVC class]);
    
    // Check to see where it comes from
    if ( [presentFromVC isKindOfClass: [UITabBarController class]] ) {
        // If come from Tab Bar Controller (Course List or Student List)
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        // It was a direct navigation from Course To Edit
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)Save:(UIBarButtonItem *)sender {
    if (self.validateDataInput) {
        // Retrieve name and weights
        NSString *name = [[self.courseName.text uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSNumber* hWeight = [NSNumber numberWithFloat:[self.hWeight.text floatValue]];
        NSNumber*  mWeight = [NSNumber numberWithFloat:[self.mWeight.text floatValue]];
        NSNumber*  fWeight = [NSNumber numberWithFloat:[self.fWeight.text floatValue]];
        
        if (!self.aCourse) {
            /* Create a new Course */
            self.aCourse = [Course newCourseInContext:self.managedObjectContext];
        }
        // We are updating an existing one
        self.aCourse.courseName = name;
        self.aCourse.hWeight = hWeight;
        self.aCourse.mWeight = mWeight;
        self.aCourse.fWeight = fWeight;
       	[self.aCourse commit];
        
        /* Go back to the previous page */
        [self Cancel:sender];
        
    } else {
        NSLog(@"Failed validation \n");
    }
    
}
@end
