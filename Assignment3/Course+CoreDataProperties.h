//
//  Course+CoreDataProperties.h
//  Assignment3
//
//  Created by david on 11/24/16.
//  Copyright © 2016 David Dang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *courseName;
@property (nullable, nonatomic, retain) NSNumber *fWeight;
@property (nullable, nonatomic, retain) NSNumber *hWeight;
@property (nullable, nonatomic, retain) NSNumber *mWeight;
@property (nullable, nonatomic, retain) NSSet<Enrollment *> *students;

@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Enrollment *)value;
- (void)removeStudentsObject:(Enrollment *)value;
- (void)addStudents:(NSSet<Enrollment *> *)values;
- (void)removeStudents:(NSSet<Enrollment *> *)values;

@end

NS_ASSUME_NONNULL_END
