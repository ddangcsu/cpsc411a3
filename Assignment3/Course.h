//
//  Course.h
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Enrollment;

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSManagedObject
+(NSMutableArray<Course*>*) fetchRowsWithPredicates: (nullable NSArray<NSPredicate*>*) predicates inContext: (NSManagedObjectContext*) context;

@end

NS_ASSUME_NONNULL_END

#import "Course+CoreDataProperties.h"
