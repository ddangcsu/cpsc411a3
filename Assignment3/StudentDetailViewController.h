//
//  StudentDetailViewController.h
//  Assignment3
//
//  Created by david on 11/21/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Utilities.h"
#import "Student.h"
#import "Course.h"
#import "Enrollment.h"

@interface StudentDetailViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) Student* aStudent;

-(IBAction) unwindFromSelectedCourseList: (UIStoryboardSegue*) segue;

@end
