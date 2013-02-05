//
//  FavouriteViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/5/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "FavouriteViewController.h"
#import "ProductsTableCell.h"
#import "Favourite.h"
#import "ProductsContentViewController.h"
#import "ModelController.h"

@interface FavouriteViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *productsTableView;
@property (strong, nonatomic) NSMutableArray *contentArray;

- (IBAction)backButtonPressed:(id)sender;


@end

@implementation FavouriteViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.contentArray = [[NSMutableArray alloc] init];
    [self.contentArray addObjectsFromArray:[[ModelController sharedManager] favouriteCategoryDataAtCategory]];
    [self.productsTableView reloadData];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProductsTableView:nil];
    [super viewDidUnload];
}

#pragma -TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.contentArray.count % 2 == 0)
        return self.contentArray.count / 2;
    else
        return (self.contentArray.count / 2) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    ProductsTableCell *cell = (ProductsTableCell *)[tableView dequeueReusableCellWithIdentifier: @"ProductsTableCell"];
    
 
    
    int firstIndex, secondIndex;
    
    firstIndex = indexPath.row * 2;
    secondIndex = firstIndex + 1;
    if ([[self.contentArray objectAtIndex:[indexPath row]] isKindOfClass:[Favourite class]]) {
        
        if (firstIndex < self.contentArray.count) {
            
            Favourite *firstDict = self.contentArray[firstIndex];
            if (firstDict.thumbnailPath == nil) {
            [cell.productImageButton1 setImage:[UIImage imageWithContentsOfFile:firstDict.thumbnailPath] forState:UIControlStateNormal];
            }
            else
            {
                [cell.productImageButton1 setImageWithURL:[NSURL URLWithString:firstDict.thumbnail]];
            }
            [cell.productImageButton1 setTag:firstIndex];
        }
        
        
        if (secondIndex < self.contentArray.count) {
            Favourite *secondDict = self.contentArray[secondIndex];
            if (secondDict.thumbnailPath == nil) {
                [cell.productImageButton2 setImage:[UIImage imageWithContentsOfFile:secondDict.thumbnailPath] forState:UIControlStateNormal];
            }
            else
            {
                [cell.productImageButton2 setImageWithURL:[NSURL URLWithString:secondDict.thumbnail]];
            }
            [cell.productImageButton2 setTag:secondIndex];
        }
        else{
            [cell.productImageButton2 setHidden:YES];
            [cell.productImageFrame2 setHidden:YES];
        }
    }
    
    [cell.productImageButton1 addTarget:self action:@selector(cellProductPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.productImageButton2 addTarget:self action:@selector(cellProductPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)cellProductPressed:(id)sender
{
    
    ProductsContentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsContentViewController" ];
    NSInteger selectedIndex = [sender tag];
    
    Favourite *content = self.contentArray[selectedIndex];

    NSDictionary *modelDict = [NSDictionary dictionaryWithObjectsAndKeys:content.productID,@"id" , content.code, @"code", content.descriptions, @"description", content.imagePath, @"imagepath", content.price, @"price",content.thumbnail, @"thumbnail",content.title, @"title",content.thumbnailPath, @"thumbnailPath", nil];
    
    [controller setProductContent:modelDict];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}



- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
