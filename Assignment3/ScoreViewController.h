//
//  ScoreViewController.h
//  Assignment3
//
//  Created by david on 11/22/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Enrollment.h"

@interface ScoreViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) Enrollment* courseScore;

@end
