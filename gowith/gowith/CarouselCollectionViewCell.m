//
//  CarouselCollectionViewCell.m
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "CarouselCollectionViewCell.h"

@interface CarouselCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *destinationImageView;
@property (strong, nonatomic) IBOutlet UILabel *destinationLabel;

@end

@implementation CarouselCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.destinationImageView.layer.borderWidth = 1;
    self.destinationImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.destinationImageView.layer.cornerRadius = 4;
    self.destinationImageView.layer.masksToBounds = YES;
    
    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
}

@end
