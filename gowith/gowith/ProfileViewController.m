//
//  PersonDetailViewController.m
//  goWith
//
//  Created by Nikhil Sharma on 14/03/14.
//  Copyright (c) 2014 Nikhil Sharma. All rights reserved.
//

#import "ProfileViewController.h"

#import <UIImageView+WebCache.h>
#import <Chameleon.h>

#import <FacebookSDK.h>
#import <UITableView+MCAdditions.h>
#import <JGProgressHUD.h>
#import "Client.h"
#import "Attractions.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, assign) CGFloat headerHeight;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *supButton;
@property (strong, nonatomic) IBOutlet UIView *redOutlineView;

@property (strong, nonatomic) IBOutlet UILabel *somethingLabel;
@property (strong, nonatomic) IBOutlet UILabel *attractionLabel2;
@property (strong, nonatomic) JGProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UILabel *attractionLabel3;

@end

@implementation ProfileViewController

- (IBAction)handleDoneButton:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleSupButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(profileViewControllerDidReceiveTapOnSupButton:)]) {
		[self.delegate profileViewControllerDidReceiveTapOnSupButton:self];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)pluralizeThing:(NSString *)thing withCount:(NSInteger)count {
	if (count > 1) {
		return [NSString stringWithFormat:@"%lu %@s", (unsigned long)count, thing];
	}
	else if (count == 1) {
		return [NSString stringWithFormat:@"%lu %@", (unsigned long)count, thing];
	}
	else {
		return [NSString stringWithFormat:@"No %@s", thing];
	}
}

- (void)setupHeaderView {
	self.tableView.tableHeaderView = nil;
	[self.tableView addSubview:self.headerView];
}

- (void)updateHeaderView {
	CGFloat width = CGRectGetWidth(self.view.bounds);

	if (self.tableView.contentOffset.y < -self.headerHeight) {
		self.headerView.frame = CGRectMake(0, self.tableView.contentOffset.y, width, -self.tableView.contentOffset.y);

		UIEdgeInsets insets = UIEdgeInsetsZero;
		insets.top = -self.tableView.contentOffset.y - 65;
		self.tableView.scrollIndicatorInsets = insets;
	}
	else {
		self.headerView.frame = CGRectMake(0, -self.headerHeight, width, self.headerHeight);
	}
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

	[self setup];
	[self setupHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.headerHeight = 65 + CGRectGetWidth(self.view.bounds);
	[self updateHeaderView];

	UIEdgeInsets insets = UIEdgeInsetsZero;
	insets.top = self.headerHeight;

	self.tableView.contentInset = insets;

	insets.top -= 65;
	self.tableView.scrollIndicatorInsets = insets;
    
    [[Client sharedInstance] retrieveDestinationAttractions:self.destination withCompletionHandler:^(NSError *error, NSArray *attractions) {
        Attractions *attract = attractions.firstObject;
        Attractions *attract2 =  [attractions objectAtIndex:2];
        Attractions *attract3 =  [attractions objectAtIndex:3];
        NSString *attract1text = [NSString stringWithFormat:@"Attraction 1: %@", attract.name];
        NSString *attract2text = [NSString stringWithFormat:@"Attraction 2: %@", attract2.name];
        NSString *attract3text = [NSString stringWithFormat:@"Attraction 3: %@", attract3.name];
        self.somethingLabel.text = attract1text;
        self.attractionLabel2.text = attract2text;
        self.attractionLabel3.text = attract3text;
    }];

    [self.tableView reloadData];
	[self.view addSubview:self.supButton];
	[self.view addSubview:self.redOutlineView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	CGFloat inset = (CGRectGetWidth(self.view.bounds) - 50) / 2;
	self.tableView.separatorInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.title = self.destination;
}

- (void)setup {
    [[Client sharedInstance] retrieveDestinationPictures:self.destination withCompletionHandler:^(NSError *error, NSArray *images) {
        Destination *destined = images.firstObject;
        NSURL *url = [NSURL URLWithString:destined.url];
        [self.userImageView sd_setImageWithURL:url placeholderImage:nil];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationSlide;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self updateHeaderView];
}

@end
