//
//  Client.m
//  goWith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "Client.h"
#import "MCNetworkActivityLogger.h"
#import "MCJSONRequestSerializer.h"
#import "MCJSONResponseSerializer.h"
#import "User.h"

#import <FacebookSDK.h>

NSString *const ClientDidUpdateUserAccountNotification = @"ClientDidUpdateUserAccountNotification";

@interface Client ()

@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, strong) User *currentUser;

@end

@implementation Client

static NSString *const kBaseURL = @"http://api.moviesapp.co/";
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

- (void)signInWithFacebookToken:(NSString *)token completion:(void (^)(NSError *error))completion {
	NSDictionary *params = @{
		@"fb_token": token
	};

	__weak typeof(self) weakSelf = self;

	[self POST:@"sessions" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.authToken = responseObject[@"auth_token"];
	    strongSelf.currentUser = [User modelWithJSONDictionary:responseObject[@"user"] error:nil];

	    [[NSNotificationCenter defaultCenter] postNotificationName:ClientDidUpdateUserAccountNotification object:nil];

	    completion(nil);
	} failure: ^(NSURLSessionDataTask *task, NSError *error) {
	    NSLog(@"error: %@", [error localizedDescription]);
	    completion(error);
	}];
}

- (void)signOut {
	self.authToken = nil;
	self.currentUser = nil;
	[[FBSession activeSession] closeAndClearTokenInformation];

	[[NSNotificationCenter defaultCenter] postNotificationName:ClientDidUpdateUserAccountNotification object:nil];
}

@end
