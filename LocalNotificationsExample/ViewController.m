//
//  ViewController.m
//  LocalNotificationsExample
//
//  Created by Ross Butler on 27/07/2015.
//  Copyright (c) 2015 Ross Butler. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// Text view listing the permissions which have been granted

@property(nonatomic, strong) IBOutlet UITextView* permissionsView;

@end

@implementation ViewController

#pragma mark - View Lifecycle -

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Listen for registration for permission to use local notifications so we can update the UI
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registeredForUserNotifications) name:@"RegisterUserNotificationSettings"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Call to super implementation
    
    [super viewWillAppear:animated];
    
    // Update the UITextView showing which permissions have been given
    
    [self updatePermissionsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Local Notifications -

// Invoked after registering for permission to use local notifications

-(void)registeredForUserNotifications
{
    // Update the text view listing granted permissions
    
    UIUserNotificationSettings* settings = [self updatePermissionsView];
    
    // Check whether we have permission to send a local notification
    
    if(settings.types != UIUserNotificationTypeNone)
    {
        // Permission has been granted - schedule a notification
        
        [self scheduleNotification];
    }
}

// Schedules a test local notification

-(void)scheduleNotification
{
    // Create a local notification
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    // Schedule for five seconds from now
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertTitle = @"Local Notifications Example";
    localNotification.alertBody = @"Here's a test notification!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Display an alert to inform user that a notification has been scheduled
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Notification Scheduled" message:@"You will receive a local notification in five seconds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    // Show the alert
    
    [alertView show];
    
}

#pragma mark - User Interface -

// Invoked on touch of the 'schedule a notification' button

-(IBAction)notificationButtonTouched:(id)sender
{
    // Check whether we are running iOS8 or above
    // Note: We do not need to register prior to iOS8 as permission was not previously required
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        // Obtain granted notification permissions
        
        UIUserNotificationSettings* settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        // Check to see whether we have permission to send a local notification
        
        if(settings.types == UIUserNotificationTypeNone)
        {
            // Check user defaults to determine whether we have requested permission already
            
            if([[NSUserDefaults standardUserDefaults] objectForKey: @"RequestedPermissions"] == nil)
            {
                // We haven't requested permissions - show the permissions request screen
                
                [self performSegueWithIdentifier:@"RequestPermissionsSegue" sender:nil];
                
            } else {
                
                // We have previously asked for permission - the user will have update using Settings app
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Allow Notifications" message:@"Navigate to Settings -> LocalNotificationsExample -> Notifications and select Allow Notifications to enable local notifications" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                // Display alert to inform user that Settings app must be used
                
                [alertView show];
            }
            
        } else{
            
            // We have permission - schedule a notification
            
            [self scheduleNotification];
            
        }
        
    } else {
        
        // No need to ask for permission (using iOS 7 or prior) - schedule a notification
        
        [self scheduleNotification];
    }
    
}

// Updates the user interface to indicate the permissions currently granted

-(UIUserNotificationSettings*)updatePermissionsView
{
    // Fetch currently granted permissions
    
    UIUserNotificationSettings* settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    // Check whether we have any permissions
    
    if(settings.types == UIUserNotificationTypeNone)
    {
        // We do not have permissions - check whether we have requested permission
        
        if([[NSUserDefaults standardUserDefaults] objectForKey: @"RequestedPermissions"] == nil){
            
            // We have not yet requested permissions
            
            [_permissionsView setText:@"Permissions not requested"];
            
        } else {
            
            // We have requested permissions but request has been denied
            
            [_permissionsView setText:@"Permissions requested - denied"];
            
        }
        
    } else {
        
        // Permissions have been granted
        
        NSMutableString* permissionsText = [[NSMutableString alloc] initWithString:@"Permissions:\n"];
        
        // Check to see whether we have permissions to display alerts
        
        if(settings.types & UIUserNotificationTypeAlert)
        {
            [permissionsText appendString:@"\tAlert\n"];
        }
        
        // Check to see whether we have permissions to display badges
        
        if(settings.types & UIUserNotificationTypeBadge)
        {
            [permissionsText appendString:@"\tBadge\n"];
        }
        
        // Check to see whether we have permissions to play sounds
        
        if(settings.types & UIUserNotificationTypeSound)
        {
            [permissionsText appendString:@"\tSound\n"];
        }
        
        // Update the text view
        
        [_permissionsView setText:permissionsText];
        
    }
    
    // Return the settings object so that we don't need to request again elsewhere
    
    return settings;
}

// Allow unwind segue from permission requests screen back to the main screen

- (IBAction)prepareForUnwind:(UIStoryboardSegue*)segue
{
}

@end
