//
//  Utilities.m
//  Assignment3
//
//  Created by david on 10/14/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(void)addDoneButtonToKeyPad:(UITextField *)field inView: (UIView *) targetView {
    // We create a Tool Bar and tell it to auto size
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    
    // We create a FlexibleSpace to fill and push the Done button to the right for us
    UIBarButtonItem *flexBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // We create a Done button.  We set the target to the view so that it can call
    // the delegate endEditing method
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: targetView action:@selector(endEditing:)];
    
    // We add the two buttons into the toolBar
    toolBar.items = @[flexBar, doneButton];
    
    // We add it to the field's Input AccesoryView
    field.inputAccessoryView = toolBar;

}
@end
