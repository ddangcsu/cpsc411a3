//
//  EnrolledStudentsTableViewController.h
//  Assignment3
//
//  Created by david on 11/24/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Course.h"
#import "Student.h"
#import "Enrollment.h"
@interface EnrolledStudentsTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray<Enrollment*>* enrolledStudents;
@end
