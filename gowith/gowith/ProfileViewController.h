//
//  PersonDetailViewController.h
//  Sup
//
//  Created by Nikhil Sharma on 22/12/14.
//  Copyright (c) 2014 Nikhil Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Destination.h"

@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>

- (void)profileViewControllerDidReceiveTapOnSupButton:(ProfileViewController *)profileViewController;

@end

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) id <ProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Destination *destination;

@end
