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

@interface StudentDetailViewController : UIViewController <UITextFieldDelegate>
@property(nonatomic, strong) NSManagedObject* aStudent;

@end
