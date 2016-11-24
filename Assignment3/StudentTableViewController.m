//
//  StudentTableViewController.m
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "StudentTableViewController.h"
#import "StudentDetailViewController.h"
#import "Student.h"

@interface StudentTableViewController ()
-(NSManagedObjectContext*) managedObjectContext;
@property (nonatomic, strong) NSMutableArray<Student*>* studentList;

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
    
    // Get Student data
    self.studentList = [Student fetchRowsWithPredicates:nil inContext:self.managedObjectContext];
    
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
    Student* aStudent = [self.studentList objectAtIndex:indexPath.row];
    NSString* firstName = aStudent.firstName;
    NSString* lastName = aStudent.lastName;
    NSString* cwid = aStudent.cwid;
	NSUInteger numOfCourses = aStudent.courses.count;
    
    /* Format string for cell */
    NSString * title = [NSString stringWithFormat:@"%@ %@ - %lu courses", firstName, lastName, numOfCourses];
    NSString * detail = [NSString stringWithFormat:@"CWID: %@", cwid];
    /* Populate the cell */
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    Student* selectedStudent = [self.studentList objectAtIndex:indexPath.row];
    if (selectedStudent.courses.count > 0){
        return NO;
    } else {
	    return YES;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Get handle to selected Student
        Student* selectedStudent = [self.studentList objectAtIndex:indexPath.row];
        // Delete it
        [selectedStudent remove];
        
        /* Remove the data from student List */
        [self.studentList removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"editStudent"]) {
        StudentDetailViewController* detailVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailVC.aStudent = [self.studentList objectAtIndex: indexPath.row];
    }
}


@end
