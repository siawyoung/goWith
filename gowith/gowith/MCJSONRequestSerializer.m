//
//  MCJSONRequestSerializer.m
//  Pods
//
//  Created by Matthew Cheok on 5/5/14.
//
//

#import "MCJSONRequestSerializer.h"
#import "MCNetworkActivityLogger.h"

@implementation MCJSONRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError **)error {
    NSMutableURLRequest *mutableRequest = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
    
    [[MCNetworkActivityLogger sharedInstance] didSerializeRequest:mutableRequest withParameters:parameters];

    return mutableRequest;
}
@end
