//
//  TestServiceOperation.m
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "TestServiceOperation.h"

@implementation TestServiceOperation

- (id)init {
    self = [super init];
    if (self) {
        self.requestServiceString = @"test.json";
    }
    return self;
}

@end
