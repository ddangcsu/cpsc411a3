//
//  CourseTableViewController.h
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CourseTableViewController : UITableViewController
@property (strong, nonatomic) NSString* segueIdentifier;
@property (strong, nonatomic) NSMutableArray* enrolledCourses;

@end
