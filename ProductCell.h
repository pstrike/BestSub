//
//  ProductCell.h
//  BestSub
//
//  Created by Pan Wang on 14-8-24.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView * image;
@property (nonatomic, strong) IBOutlet UILabel * name;
@property (nonatomic, strong) IBOutlet UILabel * size;
@property (nonatomic, strong) IBOutlet UILabel * weight;
@property (nonatomic, strong) IBOutlet UILabel * material;

@end
