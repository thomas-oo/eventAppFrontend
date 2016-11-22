#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "Event.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    [Parse enableLocalDatastore];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"myAppId";
        configuration.server = @"https://eventapptest.herokuapp.com/parse";
        configuration.localDatastoreEnabled = YES;
    }]];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    /*PFGeoPoint *pfEventLocation = [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
    Event *pfEvent = [[Event alloc] initEventWithName:@"Test" Host:@"Thomas Oo" StartTime:[[NSDate alloc] init] EndTime:[[NSDate alloc] init] Location:pfEventLocation Price:@30];
    [pfEvent saveInBackground];*/
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:[NSArray arrayWithObjects:@"user_events", nil] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
