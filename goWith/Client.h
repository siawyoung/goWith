//
//  Client.h
//  goWith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import <AFNetworking.h>
#import "AFHTTPSessionManager.h"

extern NSString* const ClientDidUpdateUserAccountNotification;

@interface Client : AFHTTPSessionManager

@property (nonatomic, copy, readonly) NSString *authToken;

+ (instancetype)sharedInstance;
- (void)signInWithFacebookToken:(NSString *)token completion:(void (^)(NSError *error))completion;
- (void)signOut;

@end
