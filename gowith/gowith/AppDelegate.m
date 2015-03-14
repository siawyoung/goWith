//
//  AppDelegate.m
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "AppDelegate.h"
#import "Client.h"
#import <MCAppRouter.h>
#import <FacebookSDK.h>
#import "AMLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) setupRouteViewControllers {
    [[MCAppRouter sharedInstance] mapRoute:@"login" toViewControllerInStoryboardWithName:@"Login" withIdentifer:@"LoginViewController"];
    
    [[MCAppRouter sharedInstance] mapRoute:@"carousel" toViewControllerInStoryboardWithName:@"Main" withIdentifer:@"MainViewController"];
    [[MCAppRouter sharedInstance] mapRoute:@"profile" toViewControllerInStoryboardWithName:@"Profile" withIdentifer:@"ProfileViewController"];
    
    [[MCAppRouter sharedInstance] mapRoute:@"messages" toViewControllerInStoryboardWithName:@"Messages" withIdentifer:@"MessagesViewController"];
}

- (void) updateRootViewController:(NSNotification *)notification {
    UIViewController *controller = nil;
    
//    if ([Client sharedInstance].signedIn) {
       controller = [[MCAppRouter sharedInstance] viewControllerMatchingRoute:@"carousel"];
//    }
//    else {
//        controller = [[AMLoginViewController alloc] init];
//    }
//    
    [UIView transitionWithView:self.window duration:notification ? 0.4 : 0 options:UIViewAnimationOptionTransitionFlipFromLeft animations: ^{
        self.window.rootViewController = controller;
    } completion:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupRouteViewControllers];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self updateRootViewController:nil];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController:) name:ClientDidUpdateUserAccountNotification object:nil];

    
    return YES;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return wasHandled;
}

@end
