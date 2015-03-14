//
//  MCNetworkActivityLogger.h
//  Pods
//
//  Created by Matthew Cheok on 5/5/14.
//
//

#import <Foundation/Foundation.h>

@interface MCNetworkActivityLogger : NSObject

@property (assign, nonatomic, getter = isLogging) BOOL logging;

+ (instancetype)sharedInstance;
- (void)didSerializeRequest:(NSURLRequest *)request withParameters:(id)parameters;
- (void)didUnserializeResponse:(NSURLResponse *)response withObject:(id)object;

@end
