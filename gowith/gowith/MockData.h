//
//  MockData.h
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Destination.h"


@interface MockData : NSObject

@property (strong, nonatomic) NSArray *mockActivities;
@property (strong, nonatomic) NSMutableArray *mockChats;

+ (instancetype)sharedInstance;
- (BOOL)mockChatsContainsActivity:(Destination *)destination;

@end
