//
//  Destination.m
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "Destination.h"

@implementation Destination

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			   @"url": @"images.large.url"
	};
}

@end
