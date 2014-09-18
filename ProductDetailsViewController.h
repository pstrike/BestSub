//
//  BestSubSecondViewController.h
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductDetailsViewController : UITableViewController

@property (nonatomic, weak, readwrite) Product* product;

@end
