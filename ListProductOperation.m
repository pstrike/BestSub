//
//  ListProductOperation.m
//  BestSub
//
//  Created by Pan Wang on 14-8-25.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "ListProductOperation.h"

@implementation ListProductOperation

- (id)init {
    self = [super init];
    if (self) {
        self.requestServiceString = @"productList.json";
    }
    return self;
}

@end
