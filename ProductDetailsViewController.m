//
//  BestSubSecondViewController.m
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ProductDetailOperation.h"
#import "OperationManager.h"

@interface ProductDetailsViewController () <NetworkOperationDelegate>

@property (nonatomic, strong) IBOutlet UIImageView * image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *material;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *packing;

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadProductDetailData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set data
- (void) setData
{
    self.image.image = self.product.image;
    self.name.text = self.product.name;
    self.weight.text = self.product.weight;
    self.size.text = self.product.size;
    self.material.text = self.product.material;
    self.packing.text = self.product.packing;
}

#pragma mark - load data via network
- (void) loadProductDetailData
{
    ProductDetailOperation* opr = [[ProductDetailOperation alloc] init];
    opr.requestMode = getMode;
    opr.delegate = self;
    opr.operationRef = @"productDetailOperation";
    [[OperationManager sharedOperationManager] addOperation:opr];
}

- (void)networkOprationDidComplete:(NSData*)responseData WithDict: (NSDictionary*) responseDict WithRef: (NSString*) operationRef
{
    NSArray* stringArray = [operationRef componentsSeparatedByString:@":"];
    NSString* ref = [stringArray objectAtIndex:0];
    
    if([ref isEqualToString:@"productDetailOperation"])
    {
        NSDictionary* dict = [NSDictionary dictionaryWithDictionary:responseDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.product.packing = [dict objectForKey:@"packing"];
            [self setData];
            [self.tableView reloadData];
        });
    }
}

@end
