//
//  CarouselCollectionViewCell.h
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Destination.h"

@interface CarouselCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *sentIndicatorView;
@property (strong, nonatomic) Destination *destination;


@end
