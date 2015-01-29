//
//  AppDelegate.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "UIColor+NPRFinder.h"
#import "BaseNavigationController.h"
#import "PrivateConstants.h"
#import "CrashlyticsLogger.h"
#import "TransitionController.h"

#import <Flannel/FLAVerboseLogFormatter.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@property (strong, nonatomic) BaseNavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:kCrashlyticsApiKey];
    
    [self setupLoggers];
        
    SplashViewController *splashViewController = [SplashViewController new];
    
    self.navigationController = [[BaseNavigationController alloc] initWithRootViewController:splashViewController];
    
    self.transitionController = [TransitionController new];
    [self.navigationController setDelegate:self.transitionController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor npr_backgroundColor];
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupLoggers {
    FLAVerboseLogFormatter *formatter = [[FLAVerboseLogFormatter alloc] init];
    
    DDASLLogger *aslLogger = [DDASLLogger sharedInstance];
    [aslLogger setLogFormatter:formatter];
    
    DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
    [ttyLogger setLogFormatter:formatter];
    
    CrashlyticsLogger *crashLogger = [CrashlyticsLogger new];
    [crashLogger setLogFormatter:formatter];

    [DDLog addLogger:ttyLogger];
    [DDLog addLogger:aslLogger];
    [DDLog addLogger:crashLogger];
}

- (void)requestUserNotificationPermissions {
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
                                       UIUserNotificationTypeSound |
                                       UIUserNotificationTypeBadge;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
