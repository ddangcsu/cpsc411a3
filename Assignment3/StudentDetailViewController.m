//
//  StudentDetailViewController.m
//  Assignment3
//
//  Created by david on 11/21/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "StudentDetailViewController.h"

@interface StudentDetailViewController ()
#pragma mark - UI Properties
@property (weak, nonatomic) IBOutlet UINavigationItem *header;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *cwid;

#pragma mark - Core Data managedObjectContext
- (NSManagedObjectContext*) managedObjectContext;

#pragma mark - Utilities Methods
-(BOOL) validateDataInput;

#pragma mark - UI Actions
- (IBAction)Cancel:(UIBarButtonItem *)sender;
- (IBAction)Save:(UIBarButtonItem *)sender;

@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.aStudent) {
        // We are editing existing student
    	self.header.title = @"Update Student";
    } else {
        self.header.title = @"New Student";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - TextField Delegation
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.cwid) {
        // We add the Button button toolbar onto the keypad
        [Utilities addDoneButtonToKeyPad:textField inView:self.view];
    }
    return YES;
}


#pragma mark - Utilities Methods
-(BOOL) validateDataInput {
    // Hide keyboard
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.cwid resignFirstResponder];
    self.labelError.text = nil;
    
    // Retrieve data
    NSString *first = [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *last = [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *cwid = [self.cwid.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (first.length <= 0) {
        self.labelError.text = @"First Name is required";
        [self.firstName becomeFirstResponder];
        return NO;
    }
    if (last.length <= 0) {
        self.labelError.text = @"Last Name is required";
        [self.lastName becomeFirstResponder];
        return NO;
    }
    if (cwid.length <= 0 || cwid.length > 9) {
        self.labelError.text = @"CWID must be 9 digits";
        [self.cwid becomeFirstResponder];
        return NO;
    }
    
    /*
    if (self.enrolledCourses.count < 1) {
        self.labelError.text = @"Remember to enroll class";
    } else if (self.enrolledCourses.count > 6) {
        self.labelError.text = @"Cannot enrolled in more than 6 courses";
        return NO;
    }
    */
    // If we get here, it means it's good
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

# pragma mark - UI Actions
- (IBAction)Cancel:(UIBarButtonItem *)sender {
    // Get the View Controller that present this Course Detail Page
    UIViewController *presentFromVC = self.presentingViewController;

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
        // Retrieve data
        NSString *firstName = [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *lastName = [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *cwid = [self.cwid.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        /* Get Context */
        NSManagedObjectContext* context = self.managedObjectContext;
        NSError* error = nil;
        
        if (! self.aStudent) {
            /* Create a new Course */
            self.aStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        } else {
            /* We are updating aCourse */
        }
        
        // We are updating an existing one
        [self.aStudent setValue:firstName forKey:@"firstName"];
        [self.aStudent setValue:lastName forKey: @"lastName"];
        [self.aStudent setValue:cwid forKey: @"cwid"];
        
        /* Save it */
        if (! [context save:&error]) {
            NSLog(@"Failed to save new course: %@\n", error);
        }
        
        /* Go back to the previous page */
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        NSLog(@"Failed data validation \n");
    }
    
}
@end
