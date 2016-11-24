//
//  StudentDetailViewController.m
//  Assignment3
//
//  Created by david on 11/21/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "CourseTableViewController.h"
#import "ScoreViewController.h"

@interface StudentDetailViewController ()
@property (strong, nonatomic) NSMutableArray<Enrollment*>* enrollmentList;

#pragma mark - UI Properties
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *cwid;
@property (weak, nonatomic) IBOutlet UITableView *enrollmentsView;

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
    	self.navigationItem.title = @"Update Student";
        
        self.firstName.text = self.aStudent.firstName;
        self.lastName.text = self.aStudent.lastName;
        self.cwid.text = self.aStudent.cwid;
        /* Get all the enrollment courses if any */
        self.enrollmentList = [[self.aStudent.courses allObjects] mutableCopy];
        
    } else {
        self.navigationItem.title = @"New Student";
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.enrollmentsView reloadData];
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

#pragma mark - TableView Delegation and Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.enrollmentList.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.aStudent) {
        // Create a toolbar and tell it to autosize itself
        UIToolbar* toolBar = [[UIToolbar alloc]init];
        [toolBar sizeToFit];
        
        // Create an Add Button of type UIBarButtonItem and tell it to invoke the method
        // performEnrollCourse defined on this View Controller
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self action:@selector(performEnrollCourse:)];
        // Create a UIBarButtonItem as a spacer
        UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
        // Create a UIView Label so that we can create the title text on it
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,20)];
        title.text = @"Enrolled Courses";
        
        // We Create another UIBarButtonItem using the UILabel we just created
        UIBarButtonItem* titleSpace = [[UIBarButtonItem alloc] initWithCustomView:title];
        
        // We put all the items on the toolBar in the order that we wanted
        // Title <space> Add Button
        toolBar.items = @[titleSpace, flexSpace, addButton];
        
        // We return the toolBar (which is a UIView and let the tableView draw it
        // In the header section
        return toolBar;
    } else {
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellId = @"registeredCourse";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    Enrollment* enrolledCourse = [self.enrollmentList objectAtIndex:indexPath.row];
    float hScore = [enrolledCourse.hScore floatValue];
    float mScore = [enrolledCourse.mScore floatValue];
    float fScore = [enrolledCourse.fScore floatValue];
    
    float courseAverage = [enrolledCourse averageScore];
    
    /* Format string for cell */
    NSString* title = [NSString stringWithFormat:@"%@ - Average: %.2f%%",[enrolledCourse valueForKeyPath:@"course.courseName"], courseAverage];
    NSString* detail = [NSString stringWithFormat:@"hScore: %.2f mScore: %.2f fScore: %.2f", hScore, mScore, fScore];
    
    /* Populate the cell */
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
	
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Get handle of the enrolled Course
        Enrollment* selectedCourse = [self.enrollmentList objectAtIndex:indexPath.row];
        [selectedCourse remove];
        
        /* Remove the data from student List */
        [self.enrollmentList removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [self.enrollmentsView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
    
    if (!self.aStudent || ![[self.aStudent valueForKey:@"cwid"] isEqualToString:cwid]){
        /* Check to make sure that we do not have the same CWID */
        NSPredicate* condition = [NSPredicate predicateWithFormat:@"cwid == %@", cwid];
        
        /* Check result */
        NSMutableArray* results = [Student fetchRowsWithPredicates:@[condition] inContext: self.managedObjectContext];

        if (results.count > 0) {
            self.labelError.text = @"CWID already exists !";
            [self.cwid setSelected:YES];
            [self.cwid becomeFirstResponder];
            return NO;
        }
    }
     // If we get here, it means it's good
    return YES;
}


#pragma mark - Navigation

-(void) performEnrollCourse: (UIBarButtonItem*) sender {
    // NSLog(@"Button click %@", sender);
    // Tell the View controller to perform the Manual Segue with teh Identifier of enrollCourses
    [self performSegueWithIdentifier:@"registerCourse" sender:sender];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"registerCourse"]) {
        NSLog(@"We are trying to enroll courses");
        // Get the Course Listing View Controller
        CourseTableViewController* courseListVC = [segue destinationViewController];
        
        // We pass the identifier so that CourseList view Controller can determine
        // whether to toggle edit mode with select only
        courseListVC.segueIdentifier = segue.identifier;
        
        NSMutableArray* excludeList = [[NSMutableArray alloc] init];
        for (Enrollment* course in self.enrollmentList) {
            [excludeList addObject:[course valueForKeyPath:@"course.courseName"]];
        }
        
        // We also pass the current enrolled Courses so that the list will be filtered
        // and only display courses that we have not register yet.
        courseListVC.excludeCourses = excludeList;
        
    } else if ([segue.identifier isEqualToString:@"editScore"]) {
        // Get the Destination View Controller
        ScoreViewController* scoreVC = segue.destinationViewController;
        NSIndexPath *selectedPath = [self.enrollmentsView indexPathForSelectedRow];
        scoreVC.courseScore = [self.enrollmentList objectAtIndex:selectedPath.row];
    }

}


-(IBAction) unwindFromSelectedCourseList: (UIStoryboardSegue*) segue {
    // NSLog(@"Unwinded from Course List");
    
    // Get enrolled Courses from sourceVC
    CourseTableViewController* courseListVC = segue.sourceViewController;
    NSMutableArray<Course*>* selectedCourses = courseListVC.selectedCourses;
    
    if (selectedCourses.count > 0) {
        // Add the selected courses
        for (Course* course in selectedCourses) {
            // We enroll the student to each of the courses
            // the Score for each score will be auto default to 0 so we do not need to set
            Enrollment* enrollment = [Enrollment newEnrollmentInContext:self.managedObjectContext];
            enrollment.student = self.aStudent;
            enrollment.course = course;
            [enrollment commit];
            
            [self.enrollmentList addObject:enrollment];
        }

        [self.enrollmentsView reloadData];
    }

}

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
        
        if (! self.aStudent) {
            /* Create a new Student */
            self.aStudent = [Student newStudentInContext:self.managedObjectContext];
        }
        
        // We are updating an existing one
        self.aStudent.firstName = firstName;
        self.aStudent.lastName = lastName;
        self.aStudent.cwid = cwid;
        // Commit changes
        [self.aStudent commit];

        /* Go back to the previous page */
        [self Cancel:sender];
        
    } else {
        NSLog(@"Failed data validation \n");
    }
    
}


@end
