//
//  ListCategoryOperation.m
//  BestSub
//
//  Created by Pan Wang on 14-8-26.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "ListCategoryOperation.h"

@implementation ListCategoryOperation

- (id)init {
    self = [super init];
    if (self) {
        self.requestServiceString = @"categoryList.json";
    }
    return self;
}

@end
