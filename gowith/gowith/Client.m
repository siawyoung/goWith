//
//  Client.m
//  goWith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "Client.h"
#import <Firebase/Firebase.h>
#import "MCNetworkActivityLogger.h"
#import "MCJSONRequestSerializer.h"
#import "MCJSONResponseSerializer.h"
#import "User.h"

#import <FacebookSDK.h>
#import "MCAlertView.h"
#import "Destination.h"
#import "Attractions.h"

NSString *const ClientDidUpdateUserAccountNotification = @"ClientDidUpdateUserAccountNotification";

@interface Client ()

@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, strong) User *currentUser;

@end

@implementation Client

static NSString *const kBaseURL = @"http://128.199.82.131/";
static NSString *const kAuthTokenHeader = @"X-Auth-Token";
static NSString *const kAPIVersionHeader = @"X-Api-Version";

+ (instancetype)sharedInstance {
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

- (instancetype)init {
	NSURL *url = [NSURL URLWithString:kBaseURL];
	self = [super initWithBaseURL:url];
	if (self) {
		[[MCNetworkActivityLogger sharedInstance] setLogging:YES];

		self.requestSerializer = [MCJSONRequestSerializer serializer];
		self.responseSerializer = [MCJSONResponseSerializer serializer];

		NSString *authToken = self.authToken;
		if (authToken.length > 0) {
			[self.requestSerializer setValue:authToken forHTTPHeaderField:kAuthTokenHeader];
		}
	}
	return self;
}

- (BOOL)signedIn {
	return self.authToken.length > 0;
}

- (void)signInToFirebaseWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSError *error))completion {
	Firebase *ref = [[Firebase alloc] initWithUrl:@"https://gowithme.firebaseio.com"];
	[ref authUser:email password:password
	       withCompletionBlock: ^(NSError *error, FAuthData *authData) {
	    if (error) {
	        NSLog(@"error: %@", error);
            [[MCAlertView alertViewWithTitle:@"Error Signing In" message:error.domain actionButtonTitle:nil cancelButtonTitle:@"Cancel" completionHandler:nil] show];

		}
	    else {
            self.authToken = authData.token;
            self.currentUser.fullName = authData.providerData[@"displayName"];
            completion(nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:ClientDidUpdateUserAccountNotification object:nil];
		}
	}];
}

- (void)signInWithFacebookToken:(NSString *)token completion:(void (^)(NSError *error))completion {
	Firebase *ref = [[Firebase alloc] initWithUrl:@"https://gowithme.firebaseio.com"];
	[ref authWithOAuthProvider:@"facebook" token:token withCompletionBlock: ^(NSError *error, FAuthData *authData) {
	    NSLog(@"my token : %@", token);
	    self.authToken = authData.token;
	    self.currentUser.fullName = authData.providerData[@"displayName"];
	    NSLog(@"token : %@", authData);
	    NSLog(@"error: %@", error);
	    completion(nil);
	}];
}

- (void)retrieveDestinationDescription:(NSString *) destination withCompletionHandler:(void (^)(NSError *error, NSString *describe))completion {
    NSString *url = [NSString stringWithFormat:@"description/%@", destination];
    [self GET:url parameters:nil success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSString *description = responseObject;
        completion(nil, description);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
        completion(error, nil);
    }];
}

- (void)retrieveDestinationPictures:(NSString *) destination withCompletionHandler:(void (^)(NSError *error, NSArray *images))completion {
    NSString *url = [NSString stringWithFormat:@"pictures/%@", destination];
    [self GET:url parameters:nil success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *images = [Destination arrayOfModelFromJSONArray:responseObject[@"data"]];
        completion(nil, images);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
        completion(error, nil);
    }];
}

- (void)retrieveDestinationAttractions:(NSString *) destination withCompletionHandler:(void (^)(NSError *error, NSArray *attractions))completion {
    NSString *url = [NSString stringWithFormat:@"attractions/%@", destination];
    [self GET:url parameters:nil success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *attractions = [Attractions arrayOfModelFromJSONArray:responseObject[@"data"]];
        completion(nil, attractions);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
        completion(error, nil);
    }];
}

- (void)signOut {
	self.authToken = nil;
	self.currentUser = nil;
	[[FBSession activeSession] closeAndClearTokenInformation];

	[[NSNotificationCenter defaultCenter] postNotificationName:ClientDidUpdateUserAccountNotification object:nil];
}

@end
