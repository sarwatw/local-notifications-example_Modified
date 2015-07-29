//
//  PermissionsRequestViewController.m
//  LocalNotificationsExample
//
//  Created by Ross Butler on 27/07/2015.
//  Copyright (c) 2015 Ross Butler. All rights reserved.
//

#import "PermissionsRequestViewController.h"

@implementation PermissionsRequestViewController

// Invoked if the user touches the button agreeing to local notifications

-(IBAction)requestPermissions:(id)sender
{
    // Check whether we are running iOS8 or above
    // Note: We do not need to register prior to iOS8 as permission was not previously required
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        
        // Register for local notifications
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          UIUserNotificationTypeAlert|
          UIUserNotificationTypeBadge|
          UIUserNotificationTypeSound categories:nil]
         ];
        
        // Set user default indicating that we have requested permissions to send local notifications
        
        [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"RequestedPermissions"];
    }
    
    // Return to the main view
    
    [self performSegueWithIdentifier:@"UnwindToFirstViewController" sender:sender];
    
}

@end
