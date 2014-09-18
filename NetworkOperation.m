//
//  NetworkOperation.m
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "NetworkOperation.h"



//static NSString *URLString= @"http://localhost/BestSub/";
static NSString *URLString= @"http://192.168.1.100/BestSub/";



@interface NetworkOperation ()
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSDictionary *responseDict;
@end


@implementation NetworkOperation

#pragma mark - init
- (id)init {
    self = [super init];
    if (self) {
        self.cancelled = NO;
        
        if (!self.responseDict)
            self.responseDict = [[NSDictionary alloc] init];
    }
    return self;
}

#pragma mark - Operaton Cancel
- (void) cancelNetworkOperation {
    self.cancelled = YES;
}

#pragma mark - Generate for Get / Post request
- (NSURLRequest*) generateURLRequest {
    
    NSMutableURLRequest* result = nil;
    
    if(self.requestServiceString)
    {
        NSMutableString* urlString =  [NSMutableString stringWithString:URLString];
        [urlString appendString:self.requestServiceString];
        
        if(self.requestMode == getMode)
        {
            [urlString appendString:@"?"];
            
            if([self generateRequestParam] != nil)
                [urlString appendString:[self generateRequestParam]];
            
            result = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
            
            //NSLog(@"send GET request to %@", urlString);
        }
        else if (self.requestMode == postMode)
        {
            result=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
            [result setHTTPMethod:@"POST"];
            
            if([self generateRequestParam] != nil)
                [result setHTTPBody:[[self generateRequestParam] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //NSLog(@"send POST request to %@", urlString);
        }
    }
    
    return result;
}

#pragma mark - Generate for request parmeter
- (NSString*) generateRequestParam {
    NSString* result = nil;
    
    if(self.requestParam != nil)
    {
        NSMutableString *tempMutableString = [[NSMutableString alloc] init];
        
        for(id key in self.requestParam)
        {
            [tempMutableString appendFormat:@"%@=%@",key,[self.requestParam objectForKey:key]];
            [tempMutableString appendString:@"&"];
        }
        
        if(tempMutableString.length != 0)
            result = [tempMutableString substringToIndex:[tempMutableString length]-1];
    }
    
    return result;
}

#pragma mark - Operation Action

- (void)main {
    @try {
        BOOL isDone = NO;
        NSError *error;
        
        // start network activity in the status bar
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        while (!self.cancelled && !isDone) {
            // Get response from server via JSON
            self.responseData = [NSURLConnection sendSynchronousRequest:[self generateURLRequest] returningResponse:nil error:nil];
            
            //Parse JSON message to Activity dictionary
            self.responseDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
            
            isDone = YES;
        }
        
        // stop network activity in the status bar
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(isDone && !self.cancelled)
            [self callback];
    }
    @catch(...) {
        // Do not rethrow exceptions.
        NSLog(@"err from network operation");
    }
}

#pragma mark - Operation Callback
- (void) callback {
    // call back via delegate
    if (self.delegate && [self.delegate respondsToSelector:
                          @selector(networkOprationDidComplete:WithDict:WithRef:)])
        [self.delegate networkOprationDidComplete:self.responseData WithDict:self.responseDict WithRef:self.operationRef];
}

@end
