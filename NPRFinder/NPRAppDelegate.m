//
//  NPRAppDelegate.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/6/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "NPRAppDelegate.h"

#import "NPRBaseNavigationController.h"
#import "NPRTransitionController.h"
#import "NPRHomeViewController.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface NPRAppDelegate ()

@property (strong, nonatomic) NPRBaseNavigationController *navigationController;

@end

@implementation NPRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    NPRHomeViewController *homeViewController = [[NPRHomeViewController alloc] init];
    
    self.navigationController = [[NPRBaseNavigationController alloc] initWithRootViewController:homeViewController];
    
    self.transitionController = [[NPRTransitionController alloc] init];
    self.navigationController.delegate = self.transitionController;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
        
    return YES;
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

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

@end
