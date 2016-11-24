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

@end
