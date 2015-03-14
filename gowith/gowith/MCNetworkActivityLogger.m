//
//  MCNetworkActivityLogger.m
//  Pods
//
//  Created by Matthew Cheok on 5/5/14.
//
//

#import "MCNetworkActivityLogger.h"

@interface MCNetworkActivityLogger ()

@property (strong, nonatomic) NSMutableDictionary *datesByURL;

@end

@implementation MCNetworkActivityLogger

+ (instancetype)sharedInstance {
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
	    _sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_datesByURL = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)didSerializeRequest:(NSURLRequest *)request withParameters:(id)parameters {
	NSString *urlString = request.URL.absoluteString;
	self.datesByURL[urlString] = [NSDate date];

	if ([self isLogging]) {
		NSData *jsonData = nil;
        if (parameters) {
            jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        }
        NSString *jsonString = nil;
		if (jsonData) {
			jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		}
		NSLog(@"\n%@ '%@'\nHeaders:\n%@\nParameters:\n%@", [request HTTPMethod], [[request URL] absoluteString], request.allHTTPHeaderFields, jsonString);
        
	}
}

- (void)didUnserializeResponse:(NSURLResponse *)response withObject:(id)object {
	if ([self isLogging]) {
		NSString *urlString = response.URL.absoluteString;

		NSTimeInterval elapsedTime = 0;
		if (self.datesByURL[urlString]) {
			elapsedTime = [[NSDate date] timeIntervalSinceDate:self.datesByURL[urlString]];
		}

		NSUInteger responseStatusCode = 0;
		if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
			responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
		}

		NSData *jsonData = nil;
        if (object) {
            jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        }
        NSString *jsonString = nil;
		if (jsonData) {
			jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		}

		NSLog(@"\n%ld '%@' [%.04f s]\nParameters:\n%@", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime, jsonString);
	}
}

@end
