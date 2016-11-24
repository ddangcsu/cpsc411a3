//
//  Enrollment.m
//  Assignment3
//
//  Created by david on 11/23/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "Enrollment.h"

@implementation Enrollment

-(float) averageScore {
    /* The Scores of this course */
    float hScore = [self.hScore floatValue];
    float mScore = [self.mScore floatValue];
    float fScore = [self.fScore floatValue];
	
    /* The Weights for this course */
    
    float hWeight = [self.course.hWeight floatValue];
    float mWeight = [self.course.mWeight floatValue];
    float fWeight = [self.course.fWeight floatValue];
    
    /* Return the average */
    return (hWeight * hScore)/100.0 + (mWeight * mScore)/100.0 + (fWeight * fScore)/100.0;
}

+(instancetype) newEnrollmentInContext:(NSManagedObjectContext *)context {
    return (Enrollment*)[NSEntityDescription insertNewObjectForEntityForName:@"Enrollment" inManagedObjectContext:context];
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
