//
//  OperationManager.h
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationManager : NSObject

+ (OperationManager *)sharedOperationManager;
- (void)addOperation:(NSOperation *)operation;

@end
