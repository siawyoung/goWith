//
//  LoginViewController.m
//  Sup
//
//  Created by Nikhil Sharma on 19/2/15.
//  Copyright (c) 2015 Nikhil Sharma. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Client.h"

#import <MCAlertView.h>
#import <JGProgressHUD.h>

@interface LoginViewController () <FBLoginViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_about_me"]];
    
    loginView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds)-50);
    loginView.delegate = self;
    
    [self.view addSubview:loginView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    if (FBSession.activeSession.isOpen) {
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        hud.textLabel.text = @"Signing in...";
        [hud showInView:self.view];
        
        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
        [[Client sharedInstance] signInWithFacebookToken:token completion:^(NSError *error) {
            [hud dismiss];
            if (error) {
                [[MCAlertView alertViewWithTitle:@"SUP" message:@"We can't sign you in right now. Please try again later." actionButtonTitle:nil cancelButtonTitle:@"OK" completionHandler:nil] show];
            }
        }];
    }

}

@end
