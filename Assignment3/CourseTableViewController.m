//
//  CourseTableViewController.m
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "CourseTableViewController.h"
#import "CourseDetailViewController.h"

@interface CourseTableViewController ()
-(NSManagedObjectContext*) managedObjectContext;
@property (strong, nonatomic) NSMutableArray<Course*>* courseList;

@end

@implementation CourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if ([self.segueIdentifier isEqualToString:@"registerCourse"]) {
        // Prepare the view to show the course appropriately for enrolling
        // We removed the left bar button and add a custom enroll button
        UIBarButtonItem *enroll = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                         target:self action:@selector(enrollSelectedCoursesButton)];
       
        self.navigationItem.title = @"Choose to Enroll";
        self.navigationItem.rightBarButtonItem = enroll;
        // We enable tableView in edit mode and allow multiple selections
        [self.tableView setAllowsMultipleSelectionDuringEditing:YES];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* See if we need to filter the fetch */
    NSArray* predicates = nil;
    if (self.excludeCourses.count > 0) {
        NSPredicate* exclude = [NSPredicate predicateWithFormat:@"NOT (courseName in %@)",self.excludeCourses];
        predicates = @[exclude];
    }
    
    // Get Courses data
    self.courseList = [Course fetchRowsWithPredicates:predicates inContext:self.managedObjectContext];
    
    // Tell Table View to refresh
    [self.tableView reloadData];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellId = @"course";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // Configure the cell...
    /* Retrieve NSManagedObject from Array */
    Course* aCourse = [self.courseList objectAtIndex:indexPath.row];
    
    NSString* courseName = aCourse.courseName;
    float hWeight = [aCourse.hWeight floatValue];
    float mWeight = [aCourse.mWeight floatValue];
    float fWeight = [aCourse.fWeight floatValue];
    NSUInteger numOfStudents = aCourse.students.count;
    
    /* Format string for cell */
    NSString *title = [NSString stringWithFormat:@"%@ - %lu registered", courseName, numOfStudents];
    NSString *detail = [NSString stringWithFormat:@"hWeight: %.2f mWeight: %.2f fWeight: %.2f", hWeight, mWeight, fWeight];
    
    /* Populate data from aCourse */
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In commitEditingStyle\n");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Get reference to selected Course
        Course* selectedCourse = [self.courseList objectAtIndex:indexPath.row];
        
        if (selectedCourse.students.count == 0) {
            // We only allow the course deletion when there are no student registered
            [selectedCourse remove];
            // Delete the object from array
            [self.courseList removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"editCourse"]) {
        /* Get destination view controller */
        CourseDetailViewController* detailVC = [segue destinationViewController];
        /* Get selected course from array for the selected row from table view */
        NSIndexPath* selectedPath = [self.tableView indexPathForCell:sender];
        Course* selectedCourse = [self.courseList objectAtIndex:selectedPath.row];
        
        /* Pass it to the detail view Controller */
        detailVC.aCourse = selectedCourse;
        
    } else if ([segue.identifier isEqualToString:@"enrollSelectedCourses"]) {
        // NSLog(@"We want to enrolled the selected courses");
        NSArray* selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
        self.selectedCourses = [[NSMutableArray alloc] init];
        
        // NSLog(@"Selected index are: %@", selectedIndexPaths);
        for(NSIndexPath *path in selectedIndexPaths) {
            Course *course = self.courseList[path.row];
            [self.selectedCourses addObject: course];
        }
    }

    
}

/* UIAction method to enrolled the list of selected courses when user click on
 the enrolled button */
-(void) enrollSelectedCoursesButton {
    NSLog(@"Button enroll Selected Course");
    NSString *segueId = @"enrollSelectedCourses";
    [self performSegueWithIdentifier:segueId sender: self.navigationItem.rightBarButtonItem];
}

@end
