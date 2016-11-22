//
//  CourseDetailViewController.m
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()
#pragma mark - UI Properties
@property (weak, nonatomic) IBOutlet UINavigationItem *header;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *hWeight;
@property (weak, nonatomic) IBOutlet UITextField *mWeight;
@property (weak, nonatomic) IBOutlet UITextField *fWeight;
#pragma mark - UI Actions
- (IBAction)Cancel:(UIBarButtonItem *)sender;
- (IBAction)Save:(UIBarButtonItem *)sender;

-(BOOL) validateDataInput;
-(NSManagedObjectContext*) managedObjectContext;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.aCourse) {
        // We have data passing in
        self.header.title = @"Course Detail";
        self.courseName.text = [self.aCourse valueForKey:@"courseName"];
        self.hWeight.text = [[self.aCourse valueForKey:@"hWeight"] stringValue];
        self.mWeight.text = [[self.aCourse valueForKey:@"mWeight"] stringValue];
        self.fWeight.text = [[self.aCourse valueForKey:@"fWeight"] stringValue];
        
    } else {
        // We are doing a new add
        self.header.title = @"New Course";
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
    if (! self.aCourse) {
        NSManagedObjectContext* context = self.managedObjectContext;
        NSError* error = nil;
        
        /* Create fetch object with condition */
        NSFetchRequest* checkCourse = [[NSFetchRequest alloc] initWithEntityName:@"Course"];
        NSPredicate* condition = [NSPredicate predicateWithFormat:@"courseName == %@", name];
        [checkCourse setPredicate:condition];
        
        /* Execute it */
        NSArray* results = [context executeFetchRequest:checkCourse error:&error];
        
        if (!results) {
            NSLog(@"Failed to check unique constraint.  %@\n", error);
            abort();
        }
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        
        /* Get Context */
        NSManagedObjectContext* context = self.managedObjectContext;
        NSError* error = nil;
        
        if (! self.aCourse) {
	        /* Create a new Course */
    	    self.aCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        } else {
            /* We are updating aCourse */
        }
        
        // We are updating an existing one
        [self.aCourse setValue:name forKey:@"courseName"];
        [self.aCourse setValue:hWeight forKey: @"hWeight"];
        [self.aCourse setValue:mWeight forKey: @"mWeight"];
        [self.aCourse setValue:fWeight forKey: @"fWeight"];
        
        /* Save it */
        if (! [context save:&error]) {
            NSLog(@"Failed to save new course: %@\n", error);
        }
        
        /* Go back to the previous page */
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        NSLog(@"Failed validation \n");
    }
    
}
@end
