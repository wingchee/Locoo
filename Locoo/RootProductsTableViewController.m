//
//  RootProductsTableViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/11/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "RootProductsTableViewController.h"
#import "ProductsTableCell.h"
#import "ProductsContentViewController.h"
#import "AFNetworking.h"


@interface RootProductsTableViewController ()

@property(strong, nonatomic) NSMutableArray *productsInfo;

- (void)cellProductPressed:(id)sender;

@end

@implementation RootProductsTableViewController

- (void)dealloc
{
    [self.productsInfo removeAllObjects];
    NSLog(@"run dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.productsInfo = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.productsInfo.count % 2 == 0)
        return self.productsInfo.count / 2;
    else
        return (self.productsInfo.count / 2) + 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsTableCell *cell = (ProductsTableCell *)[tableView dequeueReusableCellWithIdentifier: @"ProductsTableCell"];

    [cell.productImageButton1 addTarget:self action:@selector(cellProductPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.productImageButton2 addTarget:self action:@selector(cellProductPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    int firstIndex, secondIndex;
    
    firstIndex = indexPath.row * 2;
    secondIndex = firstIndex + 1;
    if ([[self.productsInfo objectAtIndex:[indexPath row]] isKindOfClass:[NSDictionary class]]) {

    if (firstIndex < self.productsInfo.count) {
        
        NSDictionary *firstDict = self.productsInfo[firstIndex];
        [cell.productImageButton1 setImageWithURL:[NSURL URLWithString:firstDict[@"thumbnail"]]];
        [cell.productImageButton1 setTag:firstIndex];
    }
    
    
    if (secondIndex < self.productsInfo.count) {
        NSDictionary *secondDict = self.productsInfo[secondIndex];
        [cell.productImageButton2 setImageWithURL:[NSURL URLWithString:secondDict[@"thumbnail"]]];
        [cell.productImageButton2 setTag:secondIndex];
    }
    else{
        [cell.productImageButton2 setHidden:YES];
        [cell.productImageFrame2 setHidden:YES];
    }
        
    }
    
    return cell;
}

- (void)cellProductPressed:(id)sender
{

   ProductsContentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsContentViewController" ];
    NSInteger selectedIndex = [sender tag];

    [controller setProductContent: [self.productsInfo objectAtIndex:selectedIndex]];
    
    controller.pageTitleImage = [UIImage imageNamed:@"title-product.png"];

    [self.navigationController pushViewController:controller animated:YES];
    
    NSLog(@"%i", selectedIndex);
    
    
    
}

-(void)didReceiveProductsinfo:(NSArray *)productInfo
{
    [self.productsInfo removeAllObjects];
 
    if (productInfo != nil)
        [self.productsInfo addObjectsFromArray:productInfo];
    

    [self.tableView reloadData];
}

@end
