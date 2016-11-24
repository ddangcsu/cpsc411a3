//
//  CourseDetailViewController.h
//  Assignment3
//
//  Created by david on 11/20/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Utilities.h"
#import "Course.h"

@interface CourseDetailViewController : UIViewController <UITextFieldDelegate>
@property(strong, nonatomic) Course* aCourse;
@end
