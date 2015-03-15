//
//  ViewController.m
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//
#import "ViewController.h"
#import "Chameleon.h"
#import "Destination.h"

#import <POP+MCAnimate.h>

#import <MCAlertView.h>
#import <MCPanGestureRecognizer.h>
#import "CarouselCollectionViewCell.h"
#import "MCAppRouter.h"
#import "ProfileViewController.h"

#import <RNFrostedSidebar.h>
#import "MCAlertView.h"

@interface ViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ProfileViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSIndexPath *draggingIndexPath;
@property (strong, nonatomic) NSArray *destinationArray;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static CGFloat const kGoWithCellWidthScaling = 0.6;
static CGFloat const kGoWithCellHeightScaling = 0.63;

@implementation ViewController

- (void)handlePan:(UIPanGestureRecognizer *)pan {
	switch (pan.state) {
		case UIGestureRecognizerStateBegan: {
			CGPoint location = [pan locationInView:self.collectionView];
			NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];

			UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

			if (CGRectContainsRect(self.collectionView.bounds, cell.frame)) {
				self.draggingIndexPath = indexPath;
			}
		}

		case UIGestureRecognizerStateChanged: {
			UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.draggingIndexPath];
			if (!cell) {
				return;
			}

			CGPoint translation = [pan translationInView:self.collectionView];
			cell.layer.pop_translationY = translation.y;


			if ([cell isKindOfClass:[CarouselCollectionViewCell class]]) {
				CGFloat progress = MIN(MAX(-translation.y / 200, 0), 1);
				CarouselCollectionViewCell *theCell = (CarouselCollectionViewCell *)cell;
				theCell.sentIndicatorView.alpha = progress;
				theCell.sentIndicatorView.pop_scaleXY = CGPointMake(1.5 - progress * 0.5, 1.5 - progress * 0.5);
			}
			break;
		}

		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled: {
			UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.draggingIndexPath];
			if (!cell) {
				return;
			}

			CGPoint translation = [pan translationInView:self.collectionView];
			CGPoint velocity = [pan velocityInView:self.collectionView];

			if (self.draggingIndexPath.item < self.destinationArray.count && velocity.y < 0 && translation.y < -80) {
				NSIndexPath *indexPath = self.draggingIndexPath;
				[NSObject pop_animate: ^{
				    cell.layer.pop_springBounciness = 0;
				    cell.layer.pop_velocity.pop_translationY = velocity.y;
				    cell.layer.pop_spring.pop_translationY = -CGRectGetHeight(self.view.bounds);
				    cell.layer.pop_spring.opacity = 0;

				    if ([cell isKindOfClass:[CarouselCollectionViewCell class]]) {
				        CarouselCollectionViewCell *theCell = (CarouselCollectionViewCell *)cell;
				        theCell.sentIndicatorView.pop_spring.alpha = 1;
				        theCell.sentIndicatorView.pop_spring.pop_scaleXY = CGPointMake(1, 1);
					}
				} completion: ^(BOOL finished) {
				    NSString *destination = self.destinationArray[indexPath.item];

				    NSMutableArray *array = [self.destinationArray mutableCopy];
				    [array removeObjectAtIndex:indexPath.item];
				    self.destinationArray = [array copy];
				    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];

//				    [self createChatWithProspect:destination];
				}];
			}
			else {
				if ([cell isKindOfClass:[CarouselCollectionViewCell class]]) {
					CarouselCollectionViewCell *theCell = (CarouselCollectionViewCell *)cell;
					theCell.sentIndicatorView.pop_spring.alpha = 0;
					theCell.sentIndicatorView.pop_spring.pop_scaleXY = CGPointMake(1.5, 1.5);
				}

				cell.layer.pop_springBounciness = 10;
				cell.layer.pop_spring.pop_translationY = 0;
			}

			self.draggingIndexPath = nil;

			break;
		}

		default:
			break;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupCollectionView];

	MCPanGestureRecognizer *pan = [[MCPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	pan.direction = MCPanGestureRecognizerDirectionVertical;
	[self.collectionView addGestureRecognizer:pan];
	self.collectionView.delaysContentTouches = NO;
}

- (void)setupCollectionView {
	self.destinationArray = @[@"Seoul", @"Jakarta", @"Moscow", @"London", @"Busan", @"Tokyo", @"Bangkok", @"Shanghai", @"Hokkaido", @"Paris"];

	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	float cellWidth = floor(screenSize.width * kGoWithCellWidthScaling);
	float cellHeight = floor(screenSize.height * kGoWithCellHeightScaling);

	double insetX = (screenSize.width - cellWidth) / 2;

	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
	self.collectionView.contentInset = UIEdgeInsetsMake(0, insetX, 0, insetX);
	self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);

	[self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CarouselCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"carouselCell" forIndexPath:indexPath];

	NSString *destination = self.destinationArray[indexPath.item];
	cell.destination = destination;
	[cell setNeedsDisplay];
	cell.sentIndicatorView.alpha = 0;
	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSLog(@"count : %lul", (unsigned long)self.destinationArray.count);
	return [self.destinationArray count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
	CGFloat index = (CGRectGetMinX(collectionView.bounds) + collectionView.contentInset.left) / (layout.itemSize.width + layout.minimumInteritemSpacing);

	if (indexPath.item != index) {
		[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
		return;
	}

	if (indexPath.item < self.destinationArray.count) {
		NSString *destination = self.destinationArray[indexPath.item];
		ProfileViewController *viewController = [[MCAppRouter sharedInstance] viewControllerMatchingRoute:@"profile"];

		viewController.delegate = self;
		viewController.destination = destination;
		self.selectedIndexPath = indexPath;

		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
		[self presentViewController:navController animated:YES completion:nil];
	}
}

- (IBAction)didTapOnOptionsButton:(id)sender {
	UIViewController *viewController = [[MCAppRouter sharedInstance] viewControllerMatchingRoute:@"messages"];
	[self presentViewController:viewController animated:YES completion:nil];
}

//    NSArray *images = @[
//                        [UIImage imageNamed:@"gear"],
//                        [UIImage imageNamed:@"globe"],
//                        [UIImage imageNamed:@"profile"],
//                        [UIImage imageNamed:@"star"]
//                        ];
//
//    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
//    callout.delegate = self;
//    [callout show];
//}
//
//- (void)closeMenu {
//    if (callout) {
//        [callout dismissAnimated:YES];
//    }
//}
//
//- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
//    [sidebar dismissAnimated:YES];
//
//    if (index == 0) {
//        MasterViewController *mvc = [[MasterViewController alloc] init];
//        [self.navigationController pushViewController:mvc animated:NO];
//    }
//    else if (index == 1) {
//        [self pushMyTripsController];
//    }
//    else if (index == 2) {
//        AMLoginViewController *amlvc = [[AMLoginViewController alloc] init];
//        [self.navigationController pushViewController:amlvc animated:NO];
//    }
//}


- (IBAction)handleRejectButton:(UIButton *)sender {
	CGPoint center = sender.center;
	CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.collectionView];
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:rootViewPoint];

	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	CGFloat index = (CGRectGetMinX(self.collectionView.bounds) + self.collectionView.contentInset.left) / (layout.itemSize.width + layout.minimumInteritemSpacing);

	if (indexPath.item != index) {
		return;
	}

	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	if ([cell isKindOfClass:[CarouselCollectionViewCell class]]) {
		CarouselCollectionViewCell *theCell = (CarouselCollectionViewCell *)cell;

		theCell.sentIndicatorView.pop_scaleXY = CGPointMake(1.5, 1.5);
		theCell.sentIndicatorView.alpha = 0;


		[NSObject pop_animate: ^{
		    theCell.sentIndicatorView.pop_spring.pop_scaleXY = CGPointMake(1, 1);
		    theCell.sentIndicatorView.pop_spring.alpha = 1;
		} completion: ^(BOOL finished) {
		    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
		    if (!cell) {
		        return;
			}

		    NSString *destination = self.destinationArray[indexPath.item];
		    [NSObject pop_animate: ^{
		        cell.layer.pop_springBounciness = 0.1;
		        cell.layer.pop_springSpeed = 5;
		        cell.layer.pop_spring.pop_translationY = CGRectGetHeight(self.view.bounds);
		        cell.layer.pop_spring.opacity = 0;
			} completion: ^(BOOL finished) {
		        NSMutableArray *array = [self.destinationArray mutableCopy];
		        [array removeObjectAtIndex:indexPath.item];
		        self.destinationArray = [array copy];

		        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
			}];
		}];
	}
}

- (IBAction)handleAddButton:(UIButton *)sender {
	CGPoint center = sender.center;
	CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.collectionView];
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:rootViewPoint];

	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	CGFloat index = (CGRectGetMinX(self.collectionView.bounds) + self.collectionView.contentInset.left) / (layout.itemSize.width + layout.minimumInteritemSpacing);

	if (indexPath.item != index) {
		return;
	}
    NSLog(@"indexpath %@", indexPath);
    if (indexPath.item == 3) {
        [[MCAlertView alertViewWithTitle:@"You've got a match!" message:@"One of your friends has also liked this destination. Would you like to chat with them?" actionButtonTitle:@"Continue" cancelButtonTitle:@"Cancel" completionHandler: ^(BOOL cancelled) {
            if (!cancelled) {
                [self didTapOnOptionsButton:self];
            }
        }] show];
    }



	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	if ([cell isKindOfClass:[CarouselCollectionViewCell class]]) {
		CarouselCollectionViewCell *theCell = (CarouselCollectionViewCell *)cell;

		theCell.sentIndicatorView.pop_scaleXY = CGPointMake(1.5, 1.5);
		theCell.sentIndicatorView.alpha = 0;

		__weak typeof(self) weakSelf = self;

		[NSObject pop_animate: ^{
		    theCell.sentIndicatorView.pop_spring.pop_scaleXY = CGPointMake(1, 1);
		    theCell.sentIndicatorView.pop_spring.alpha = 1;
		} completion: ^(BOOL finished) {
            typeof(self) strongSelf = weakSelf;
            [strongSelf removeCardFromCarousel:indexPath];
		}];
	}
}

- (void)removeCardFromCarousel:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	if (!cell) {
		return;
	}

	NSString *destination = self.destinationArray[indexPath.item];
	[NSObject pop_animate: ^{
	    cell.layer.pop_springBounciness = 0.1;
	    cell.layer.pop_springSpeed = 5;
	    cell.layer.pop_spring.pop_translationY = -CGRectGetHeight(self.view.bounds);
	    cell.layer.pop_spring.opacity = 0;
	} completion: ^(BOOL finished) {
	    NSMutableArray *array = [self.destinationArray mutableCopy];
	    [array removeObjectAtIndex:indexPath.item];
	    self.destinationArray = [array copy];

	    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
	}];

//    [self createChatWithProspect:destination];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChatArray Updated" object:nil];
}

#pragma mark - ProfileViewControllerDelegate

- (void)profileViewControllerDidReceiveTapOnSupButton:(ProfileViewController *)profileViewController {
	[self performSelector:@selector(removeCardFromCarousel:) withObject:self.selectedIndexPath afterDelay:0.5];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	double cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing;
	CGPoint offset = *targetContentOffset;

	double index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing;
	double roundedIndex = round(index);

	offset = CGPointMake(roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, -scrollView.contentInset.top);
	*targetContentOffset = offset;
}

@end
