//
//  Utilities.h
//  Assignment3
//
//  Created by david on 10/14/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

// Helper Function to add Done Button to Numeric Keypad
+(void) addDoneButtonToKeyPad: (UITextField*) field inView: (UIView *) targetView; 

@end
