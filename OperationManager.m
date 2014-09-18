//
//  OperationManager.m
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "OperationManager.h"



static int const CONCURRENT_OPERATION_SIZE = 10;



@interface OperationManager ()
@property (nonatomic, retain, readonly ) NSOperationQueue *operationQueue;
@end



@implementation OperationManager

+ (OperationManager *)sharedOperationManager
{
    static OperationManager * sOperationManager;
    
    // This can be called on any thread, so synchronise.
    if (sOperationManager == nil) {
        @synchronized (self) {
            sOperationManager = [[OperationManager alloc] init];
        }
    }
    return sOperationManager;
}

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        
        // Create the network management queue.  We will run an unbounded number of these operations
        // in parallel because each one consumes minimal resources.
        
        _operationQueue = [[NSOperationQueue alloc] init];
        
        [_operationQueue setMaxConcurrentOperationCount:CONCURRENT_OPERATION_SIZE];
    }
    
    return self;
}

- (void)addOperation:(NSOperation *)operation
{
    [self.operationQueue addOperation:operation];
}

@end
