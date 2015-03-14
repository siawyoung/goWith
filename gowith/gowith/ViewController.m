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

@interface ViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSIndexPath *draggingIndexPath;
@property (strong, nonatomic) NSMutableArray *destinationArray;

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
				    Destination *destination = self.destinationArray[indexPath.item];

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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
