//
//  DownloadImageOperation.m
//  BestSub
//
//  Created by Pan Wang on 14-8-24.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation

- (id)init {
    self = [super init];
    if (self) {
        //self.requestServiceString = @"image";
    }
    return self;
}

- (NSString*) requestServiceString
{
    return [NSString stringWithFormat:@"%@/%@",@"image",self.imgaeURLString];
}

@end
