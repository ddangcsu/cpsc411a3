//
//  EnrolledStudentsTableViewController.m
//  Assignment3
//
//  Created by david on 11/24/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "EnrolledStudentsTableViewController.h"

@interface EnrolledStudentsTableViewController ()

@end

@implementation EnrolledStudentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    if (self.enrolledStudents) {
        self.navigationItem.title = @"Enrolled Students";
    }
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.enrolledStudents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellId = @"enrolledStudent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    Enrollment* enrolledStudent = [self.enrolledStudents objectAtIndex:indexPath.row];

    // Configure the cell...
    NSString* title = [NSString stringWithFormat:@"%@ %@ CWID: %@", enrolledStudent.student.firstName,
                       enrolledStudent.student.lastName, enrolledStudent.student.cwid];
    NSString* detail = [NSString stringWithFormat:@"Course Average: %.2f %%", enrolledStudent.averageScore];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
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
