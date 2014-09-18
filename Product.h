//
//  Product.h
//  BestSub
//
//  Created by Pan Wang on 14-8-24.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *material;
@property (nonatomic, strong) NSString *packing;

@end
