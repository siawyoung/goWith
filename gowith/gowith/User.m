//
//  User.m
//  goWith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uuid": @"id",
             @"facebookId": @"fb_id",
             @"fullName" : @"name",
             @"avatarUrl" : @"profile_picture",
             @"mutualFriends": @"mutual_friends",
             @"birthDate" : @"birthday",
             };
}

@end
