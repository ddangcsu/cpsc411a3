//
//  Course.m
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "Course.h"
#import "Enrollment.h"

@implementation Course

+(NSMutableArray<Course*>*) fetchRowsWithPredicates: (nullable NSArray<NSPredicate*>*) predicates inContext: (NSManagedObjectContext*) context {
    NSError* error = nil;
    
    // Create a fetch request
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Course"];
    // Set all the predicate
    for (NSPredicate* predicate in predicates) {
        [fetchRequest setPredicate: predicate];
    }
    
    // Execute it
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    if (! results) {
        NSLog(@"Failed to fetch data in Course %@\n", error);
        abort();
    }
    
    // Return the result
    return [results mutableCopy];
    
}

+(instancetype) newCourseInContext:(NSManagedObjectContext *)context {
    return (Course*)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
}

-(BOOL) remove {
    NSManagedObjectContext* context = self.managedObjectContext;
    [context deleteObject:self];
    return [self commit];
}

-(BOOL) commit {
    NSManagedObjectContext* context = self.managedObjectContext;
    NSError* error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Failed to save Student %@\n", error);
        abort();
    }
    return YES;
}


@end
