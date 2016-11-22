//
//  StudentTableViewController.m
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "StudentTableViewController.h"

@interface StudentTableViewController ()
-(NSManagedObjectContext*) managedObjectContext;
@property (nonatomic, strong) NSMutableArray* studentList;

@end

@implementation StudentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* get context */
    NSError* error = nil;
    NSManagedObjectContext* context = self.managedObjectContext;
    NSFetchRequest* fetchAllStudents = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    
    /* Execute the query and convert the result NSArray into NSMutableArray */
    self.studentList = [[context executeFetchRequest:fetchAllStudents error:&error] mutableCopy];
    if (!self.studentList) {
        NSLog(@"Error fetching students %@\n", error);
        abort();
    }
    
    /* Tell the tableview to refresh itself */
    [self.tableView reloadData];
    
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
    return self.studentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellId = @"student";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // Configure the cell...
    /* Retrieve the object from array */
    NSManagedObject* aStudent = [self.studentList objectAtIndex:indexPath.row];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", [aStudent valueForKey:@"firstName"], [aStudent valueForKey:@"lastName"]];
    NSString* cwid = [aStudent valueForKey:@"cwid"];
	
    /* Populate the cell */
    cell.textLabel.text = fullName;
    cell.detailTextLabel.text = cwid;
    
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
        /* Get context */
        NSError* error = nil;
        NSManagedObjectContext* context = self.managedObjectContext;
        
        /*Delete it */
        [context deleteObject:[self.studentList objectAtIndex:indexPath.row]];
        if (! [context save:&error]) {
            NSLog(@"Failed to delete student %@\n", error);
            abort();
        }
        
        /* Remove the data from student List */
        [self.studentList removeObjectAtIndex:indexPath.row];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
