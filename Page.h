//
//  Page.h
//  BestSub
//
//  Created by Pan Wang on 14-8-31.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject

@property int page;
@property int itemNo;
@property BOOL isEndPage;

- (int) nextPage;


@end
