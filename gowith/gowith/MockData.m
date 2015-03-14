//
//  MockData.m
//  gowith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "MockData.h"
#import "Chat.h"

@implementation MockData

+ (instancetype)sharedInstance {
	static dispatch_once_t pred = 0;
	__strong static MockData *_sharedObject = nil;
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

- (NSArray *)mockActivities {
	if (!_mockActivities) {

		NSArray *data = @[
		    @{
		        @"location": @"Las Vegas",
		        @"swipe_status": @"sent",
                @"destination_picture": @"picture-vegas"
			},
            @{
                @"location": @"Kuala Lumpur",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-kl"
                },
            @{
                @"location": @"Seoul",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-seoul"
                },
            @{
                @"location": @"Jakarta",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-jakarta"
                },
            @{
                @"location": @"San Francisco",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-sf"
                },
            @{
                @"location": @"London",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-london"
                },
            @{
                @"location": @"Shanghai",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-shanghai"
                },
            @{
                @"location": @"Rio de Janeiro",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-rio"
                },
            @{
                @"location": @"Moscow",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-moscow"
                },
            @{
                @"location": @"Cape Town",
                @"swipe_status": @"sent",
                @"destination_picture": @"picture-cape-town"
                },
		];

        _mockActivities = [Destination arrayOfModelFromJSONArray:data];
	}

	return _mockActivities;
}

- (NSMutableArray *)mockChats {
	if (!_mockChats) {
		_mockChats = [NSMutableArray array];
	}

	return _mockChats;
}

- (BOOL)mockChatsContainsActivity:(Destination *)destination {
	for (Chat *chat in self.mockChats) {
		if (chat.destination == destination) {
			return YES;
		}
	}
	return NO;
}

@end
