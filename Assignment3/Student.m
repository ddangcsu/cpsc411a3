//
//  Student.m
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "Student.h"
#import "Enrollment.h"

@implementation Student

+(NSMutableArray<Student*>*) fetchRowsWithPredicates: (nullable NSArray<NSPredicate*>*) predicates inContext: (NSManagedObjectContext*) context {
    NSError* error = nil;
    
    // Create a fetch request
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Student"];
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

+(instancetype) newStudentInContext: (NSManagedObjectContext*) context {
    return (Student*)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
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
