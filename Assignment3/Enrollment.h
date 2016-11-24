//
//  Enrollment.h
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Enrollment : NSManagedObject

-(float) averageScore;

@end

NS_ASSUME_NONNULL_END

#import "Enrollment+CoreDataProperties.h"
