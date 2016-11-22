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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* Get CoreData context */
    NSManagedObjectContext* context = self.managedObjectContext;
    NSError* error = nil;
    
    /* Create a fetch request against Course table */
    NSFetchRequest *fetchAllCourses = [[NSFetchRequest alloc] initWithEntityName:@"Course"];
    
    /* Execute the query and save it into courseList */
    self.courseList = [[context executeFetchRequest:fetchAllCourses error:&error] mutableCopy];
    
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
    
    NSString *courseName = [aCourse valueForKey:@"courseName"];
    
	NSString *courseInfo = [NSString stringWithFormat:@"hWeight: %@ mWeight: %@ fWeight: %@",
                            [aCourse valueForKey:@"hWeight"],
                            [aCourse valueForKey:@"mWeight"],
                            [aCourse valueForKey:@"fWeight"]];
    
    /* Populate data from aCourse */
    cell.textLabel.text = courseName;
    cell.detailTextLabel.text = courseInfo;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /* Get Context */
        NSManagedObjectContext* context = self.managedObjectContext;
        NSError* error = nil;
        
        NSManagedObject* selectedCourse = [self.courseList objectAtIndex:indexPath.row];
        
        /* Tell the context to deleted the selectedCourse */
        [context deleteObject:selectedCourse];
        
        if (! [context save:&error]) {
            NSLog(@"Failed to remove seleted course %@\n", error);
        }
        
        // Delete the object from array
        [self.courseList removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        NSManagedObject* selectedCourse = [self.courseList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        /* Pass it to the detail view Controller */
        detailVC.aCourse = selectedCourse;
    }
    
}


@end
