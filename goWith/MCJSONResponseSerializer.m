//
//  MCJSONResponseSerializer.m
//  Saleswhale
//
//  Created by Matthew Cheok on 16/4/14.
//  Copyright (c) 2014 Getting Real. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const MCJSONResponseSerializerBodyKey = @"MCJSONResponseSerializerBodyKey";
NSString *const MCJSONResponseSerializerStatusCodeKey = @"MCJSONResponseSerializerStatusCodeKey";

#import "MCJSONResponseSerializer.h"
#import "MCNetworkActivityLogger.h"

@implementation MCJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
	id JSONObject = [super responseObjectForResponse:response data:data error:error]; // may mutate `error`

    NSString *statusCode = [response valueForKey:@"statusCode"];
    
	if (*error != nil) {
		NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
		[userInfo setValue:statusCode forKey:MCJSONResponseSerializerStatusCodeKey];

        if (JSONObject) {
            [userInfo setValue:JSONObject forKey:MCJSONResponseSerializerBodyKey];
        }
        if (JSONObject && [JSONObject objectForKey:@"error_msg"]) {
            [userInfo setValue:JSONObject[@"error_msg"] forKey:NSLocalizedDescriptionKey];
        }
        
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		(*error) = newError;
	}
    
    
    [[MCNetworkActivityLogger sharedInstance] didUnserializeResponse:response withObject:JSONObject];

	return JSONObject;
}

@end
