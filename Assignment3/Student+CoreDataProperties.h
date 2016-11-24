//
//  Student+CoreDataProperties.h
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cwid;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<Enrollment *> *courses;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Enrollment *)value;
- (void)removeCoursesObject:(Enrollment *)value;
- (void)addCourses:(NSSet<Enrollment *> *)values;
- (void)removeCourses:(NSSet<Enrollment *> *)values;

@end

NS_ASSUME_NONNULL_END
