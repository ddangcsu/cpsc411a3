//
//  Enrollment+CoreDataProperties.h
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Enrollment.h"
#import "Course.h"
#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Enrollment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *fScore;
@property (nullable, nonatomic, retain) NSNumber *hScore;
@property (nullable, nonatomic, retain) NSNumber *mScore;
@property (nullable, nonatomic, retain) Course *course;
@property (nullable, nonatomic, retain) Student *student;

@end

NS_ASSUME_NONNULL_END
