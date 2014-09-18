//
//  BestSubFirstViewController.m
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import "ProductListViewController.h"
#import "OperationManager.h"
#import "NetworkOperation.h"
#import "ListProductOperation.h"
#import "Product.h"
#import "ProductCell.h"
#import "DownloadImageOperation.h"
#import "ProductDetailsViewController.h"
#import "Page.h"


#define kTableViewContentDisplaySection 0 //represents content section
#define kLoadMoreButtonSection 1 //represents load more section

static NSString *ProductListString= @"productList";
static NSString *SearchProductListString= @"searchProductList";

@interface ProductListViewController () <NetworkOperationDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) Page *productPage;
@property (nonatomic, strong) Page *searchProductPage;

@property BOOL isLoadingData;
@property BOOL isSearchLoadingData;

@end

@implementation ProductListViewController

#pragma mark - page initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.products = [[NSArray alloc] init];
    self.searchProducts = [[NSArray alloc] init];
    self.productPage = [[Page alloc] init];
    self.searchProductPage = [[Page alloc] init];
    self.isLoadingData = NO;
    self.isSearchLoadingData = NO;
    
    [self setLayout];
    [self loadProductData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout
{
    /*
    // To hide navigation bar shadow
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // Draw a line to separate header and table view
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 114.0)];
    [path addLineToPoint:CGPointMake(320.0, 114.0)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:229.0/255.0 alpha:1.0] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
     */
    
    // Set logo in navigation bar
    if(self.category == nil)
    {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    }
    else
    {
        self.navigationItem.title = self.category;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

#pragma mark - load data via network
- (void) loadProductData
{
    /*
    Product *product = [[Product alloc] init];
    product.name = @"11oz Full Color Mug";
    product.size = @"φ8.2*H9.5cm";
    product.imageURLString = @"Product3.jpg";
    product.material = @"Ceramic";
    product.weight = @"15kg";
    NSArray* tempProducts = [NSArray arrayWithObjects:product, nil];
    self.products = [NSMutableArray arrayWithArray:tempProducts];
     */
    
    ListProductOperation* opr = [[ListProductOperation alloc] init];
    opr.requestMode = getMode;
    opr.delegate = self;
    opr.requestParam = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", [self.productPage nextPage]],[NSString stringWithFormat:@"%d", self.productPage.itemNo],nil] forKeys:[NSArray arrayWithObjects:@"page",@"no",nil]];
    opr.operationRef = @"listProductOperation";
    [[OperationManager sharedOperationManager] addOperation:opr];
    
    self.isLoadingData = YES;
}

- (void) searchProductData: (NSString*) searchText
{
    ListProductOperation* opr = [[ListProductOperation alloc] init];
    opr.requestMode = getMode;
    opr.delegate = self;
    opr.requestParam = [NSDictionary dictionaryWithObject:searchText forKey:@"search"];
    opr.operationRef = @"searchProductOperation";
    [[OperationManager sharedOperationManager] addOperation:opr];
    
    self.isSearchLoadingData = YES;
}

- (void)startImageDownload:(Product *)product forIndexPath:(NSIndexPath *)indexPath forList: (NSString *) list
{
    DownloadImageOperation* iconDownloader = [[DownloadImageOperation alloc] init];
    iconDownloader.requestMode = getMode;
    iconDownloader.delegate = self;
    iconDownloader.operationRef = [NSString stringWithFormat:@"downloadImage:%@:%@",[@(indexPath.row) stringValue],list];
    iconDownloader.imgaeURLString = product.imageURLString;
    [[OperationManager sharedOperationManager] addOperation:iconDownloader];
}

- (void)networkOprationDidComplete:(NSData*)responseData WithDict: (NSDictionary*) responseDict WithRef: (NSString*) operationRef
{
    NSArray* stringArray = [operationRef componentsSeparatedByString:@":"];
    NSString* ref = [stringArray objectAtIndex:0];
    
    if([ref isEqualToString:@"listProductOperation"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* dict = [NSDictionary dictionaryWithDictionary:responseDict];
            NSArray* tempProductListDict = [dict objectForKey:@"productList"];
            NSMutableArray* tempProductList = [[NSMutableArray alloc] init];
            
            [tempProductList addObjectsFromArray:self.products];
            
            for(id object in tempProductListDict)
            {
                NSDictionary* productDict = object;
                Product* product = [[Product alloc] init];
                product.name = [productDict objectForKey:@"name"];
                product.size = [productDict objectForKey:@"size"];
                product.weight = [productDict objectForKey:@"weight"];
                product.material = [productDict objectForKey:@"material"];
                product.imageURLString = [productDict objectForKey:@"imageURL"];
                
                [tempProductList addObject:product];
            }
            
            if([tempProductListDict count] != self.productPage.itemNo)
            {
                self.productPage.isEndPage = YES;
            }
            
            self.products = [NSArray arrayWithArray:tempProductList];
            
            [self.tableView reloadData];
            self.isLoadingData = NO;
        });
    }
    else if ([ref isEqualToString:@"downloadImage"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* rowString = [stringArray objectAtIndex:1];
            NSString* listString = [stringArray objectAtIndex:2];
            Product *product;
            
            if([listString isEqualToString:SearchProductListString])
            {
                product = [self.searchProducts objectAtIndex:[rowString integerValue]];
            }
            else
            {
                product = [self.products objectAtIndex:[rowString integerValue]];
            }
            
            UIImage *image = [[UIImage alloc] initWithData:responseData];
            
            if (image.size.width != 100 || image.size.height != 100)
            {
                CGSize itemSize = CGSizeMake(100, 100);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                product.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                product.image = image;
            }
            
            if([listString isEqualToString:SearchProductListString])
            {
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
            else
            {
                [self.tableView reloadData];
            }
        });
    }
    else if ([ref isEqualToString:@"searchProductOperation"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* dict = [NSDictionary dictionaryWithDictionary:responseDict];
            NSArray* tempProductListDict = [dict objectForKey:@"productList"];
            NSMutableArray* tempProductList = [[NSMutableArray alloc] init];
            
            [tempProductList addObjectsFromArray:self.searchProducts];
            
            for(id object in tempProductListDict)
            {
                NSDictionary* productDict = object;
                Product* product = [[Product alloc] init];
                product.name = [productDict objectForKey:@"name"];
                product.size = [productDict objectForKey:@"size"];
                product.weight = [productDict objectForKey:@"weight"];
                product.material = [productDict objectForKey:@"material"];
                product.imageURLString = [productDict objectForKey:@"imageURL"];
                
                [tempProductList addObject:product];
            }
            
            if([tempProductListDict count] != self.searchProductPage.itemNo)
            {
                self.searchProductPage.isEndPage = YES;
            }
            
            self.searchProducts = [NSArray arrayWithArray:tempProductList];
            [self.searchDisplayController.searchResultsTableView reloadData];
            self.isSearchLoadingData = NO;
        });
    }
}

#pragma mark - action handle

- (void)loadImagesForOnscreenRowsforList: (NSString*) list
{
    NSArray *visiblePaths;
    Product *product;
    
    if([list isEqualToString:SearchProductListString])
    {
        visiblePaths = [self.searchDisplayController.searchResultsTableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths)
        {
            product = [self.searchProducts objectAtIndex:indexPath.row];
            
            if (!product.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:product forIndexPath:indexPath forList:list];
            }
        }
    }
    else
    {
        visiblePaths = [self.tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths)
        {
            product = [self.products objectAtIndex:indexPath.row];
            
            if (!product.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:product forIndexPath:indexPath forList:list];
            }
        }
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kLoadMoreButtonSection)
    {
        return 1;
    }
    else
    {
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            return [self.searchProducts count];
        }
        else
        {
            return [self.products count];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    NSUInteger nodeCount;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        nodeCount = [self.searchProducts count];
    }
    else
    {
        nodeCount = [self.products count];
    }
    
    if (indexPath.section== kLoadMoreButtonSection){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];

        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    ProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaceholderCellIdentifier];
    }
    
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        Product *product;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            product = [self.searchProducts objectAtIndex:indexPath.row];
        }
        else
        {
            product = [self.products objectAtIndex:indexPath.row];
        }
        
		cell.name.text = product.name;
        cell.size.text = product.size;
        cell.material.text = product.material;
        cell.weight.text = product.weight;
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!product.image)
        {
            if (tableView.dragging == NO && tableView.decelerating == NO)
            {
                if (tableView == self.searchDisplayController.searchResultsTableView)
                {
                    [self startImageDownload:product forIndexPath:indexPath forList:SearchProductListString];
                }
                else
                {
                    [self startImageDownload:product forIndexPath:indexPath forList:ProductListString];
                }
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.image.image = [UIImage imageNamed:@"Placeholder.png"];
        }
        else
        {
            cell.image.image = product.image;
        }
        
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        if(self.searchProductPage.isEndPage || [self.searchProducts count] == 0)
            result = kLoadMoreButtonSection;
        else
            result = kLoadMoreButtonSection + 1;
    }
    else
    {
        if(self.productPage.isEndPage || [self.products count] == 0)
            result = kLoadMoreButtonSection;
        else
            result = kLoadMoreButtonSection + 1;
    }
    
    return result;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kLoadMoreButtonSection)
        return 44;
    else
        return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == kLoadMoreButtonSection){ //If it is the load more section
        if (indexPath.row==0 ){//if it is the first row
            NSLog(@"load more data");
            if(tableView == self.searchDisplayController.searchResultsTableView && !self.isSearchLoadingData && ![self.searchProducts count] == 0)
            {
                [self searchProductData:self.searchDisplayController.searchBar.text];
            }
            else if (tableView == self.tableView && !self.isLoadingData && ![self.products count] == 0)
            {
                [self loadProductData];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        if(scrollView == self.tableView)
        {
            [self loadImagesForOnscreenRowsforList:ProductListString];
        }
        else if(scrollView == self.searchDisplayController.searchResultsTableView)
        {
            [self loadImagesForOnscreenRowsforList:SearchProductListString];
        }
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.tableView)
    {
        [self loadImagesForOnscreenRowsforList:ProductListString];
    }
    else if(scrollView == self.searchDisplayController.searchResultsTableView)
    {
        [self loadImagesForOnscreenRowsforList:SearchProductListString];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"productDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProductDetailsViewController *detailVC = [segue destinationViewController];
        detailVC.product = [self.products objectAtIndex:indexPath.row];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"load search result");
    [self searchProductData:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchProducts = [NSArray array];
}

@end
