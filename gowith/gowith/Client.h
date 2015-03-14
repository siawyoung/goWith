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
@property (nonatomic, assign, readonly) BOOL signedIn;

+ (instancetype)sharedInstance;
- (void)signInWithFacebookToken:(NSString *)token completion:(void (^)(NSError *error))completion;
- (void)signOut;

- (void)signInToFirebaseWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSError *error))completion;

- (void)retrieveDestinationDescription:(NSString *) destination withCompletionHandler:(void (^)(NSError *error, NSString *describe))completion;
- (void)retrieveDestinationPictures:(NSString *) destination withCompletionHandler:(void (^)(NSError *error, NSArray *images))completion;
- (void)retrieveDestinationAttractions:(NSString *) destination withCompletionHandler:(void (^)(NSError *error, NSArray *attractions))completion;

@end
