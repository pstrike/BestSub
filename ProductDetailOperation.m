//
//  ProductDetailOperation.m
//  BestSub
//
//  Created by Pan Wang on 14-8-26.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "ProductDetailOperation.h"

@implementation ProductDetailOperation

- (id)init {
    self = [super init];
    if (self) {
        self.requestServiceString = @"productDetails.json";
    }
    return self;
}

@end
