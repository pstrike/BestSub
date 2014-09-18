//
//  Page.m
//  BestSub
//
//  Created by Pan Wang on 14-8-31.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "Page.h"

#define kPageItemNo 5 //represents load more section

@implementation Page

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        
        // Create the network management queue.  We will run an unbounded number of these operations
        // in parallel because each one consumes minimal resources.
        
        _page = 0;
        _itemNo = kPageItemNo;
        _isEndPage = NO;
    }
    
    return self;
}

- (int) nextPage
{
    return ++self.page;
}

@end
