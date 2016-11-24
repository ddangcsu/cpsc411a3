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
@property (strong) NSMutableArray* courseList;

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
    /* Get CoreData context */
    NSManagedObjectContext* context = self.managedObjectContext;
    NSError* error = nil;
    
    /* Create a fetch request against Course table */
    NSFetchRequest *fetchCourses = [[NSFetchRequest alloc] initWithEntityName:@"Course"];
    
    /* See if we need to filter the fetch */
    if (self.enrolledCourses.count > 0) {
        NSPredicate* exclude = [NSPredicate predicateWithFormat:@"NOT (courseName in %@)",self.enrolledCourses];
        [fetchCourses setPredicate:exclude];
    }
    /* Execute the query and save it into courseList */
    self.courseList = [[context executeFetchRequest:fetchCourses error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Failed fetching Course data: %@\n", error);
    }
    
    /* Tell Table View to refresh */
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
    NSManagedObject* aCourse = [self.courseList objectAtIndex:indexPath.row];
    
    NSString* courseName = [aCourse valueForKey:@"courseName"];
    NSNumber* hWeight = [aCourse valueForKey:@"hWeight"];
    NSNumber* mWeight = [aCourse valueForKey:@"mWeight"];
    NSNumber* fWeight = [aCourse valueForKey:@"fWeight"];
    NSSet *registeredStudents = [aCourse valueForKey:@"students"];
    
    /* Format string for cell */
    NSString *title = [NSString stringWithFormat:@"%@ - %lu registered", courseName, registeredStudents.count];
    NSString *detail = [NSString stringWithFormat:@"hWeight: %@ mWeight: %@ fWeight: %@", hWeight, mWeight, fWeight];
    
    /* Populate data from aCourse */
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    NSManagedObject* selectedCourse = [self.courseList objectAtIndex:indexPath.row];
    if ([[selectedCourse valueForKey:@"students"] count] > 0) {
        return NO;
    } else {
	    return YES;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In commitEditingStyle\n");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Get Context
        NSManagedObjectContext* context = self.managedObjectContext;
        NSError* error = nil;
        
        NSManagedObject* selectedCourse = [self.courseList objectAtIndex:indexPath.row];
        
        // Tell the context to deleted the selectedCourse
        [context deleteObject:selectedCourse];
        
        if (! [context save:&error]) {
            NSLog(@"Failed to remove seleted course %@\n", error);
        }
        
        // Delete the object from array
        [self.courseList removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
        NSManagedObject* selectedCourse = [self.courseList objectAtIndex:selectedPath.row];
        
        /* Pass it to the detail view Controller */
        detailVC.aCourse = selectedCourse;
        
    } else if ([segue.identifier isEqualToString:@"enrollSelectedCourses"]) {
        // NSLog(@"We want to enrolled the selected courses");
        NSArray* selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
        self.enrolledCourses = [[NSMutableArray alloc] init];
        
        // NSLog(@"Selected index are: %@", selectedIndexPaths);
        for(NSIndexPath *path in selectedIndexPaths) {
            NSManagedObject *course = self.courseList[path.row];
            [self.enrolledCourses addObject: [course valueForKey:@"courseName"]];
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
