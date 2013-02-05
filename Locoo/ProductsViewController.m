//
//  ProductsViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/1/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductsTableCell.h"
#import "AFNetworking.h"
#import "DressProductsTableViewController.h"
#import "TopProductsTableViewController.h"
#import "BottomProductsTableViewController.h"
#import "AccessoriesProductsTableViewController.h"


@interface ProductsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    DressProductsTableViewController *dressProductsTableViewController;
    TopProductsTableViewController *topProductsTableViewController;
    BottomProductsTableViewController *bottomProductsTableViewController;
    AccessoriesProductsTableViewController *accessoriesProductsTableViewController;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *dressTableViewContainer;
@property (weak, nonatomic) IBOutlet UIView *topTableViewContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomTableViewContainer;
@property (weak, nonatomic) IBOutlet UIView *accessoriesTableViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *productsTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *productsViewActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *dressTabButton;
@property (weak, nonatomic) IBOutlet UIButton *topTabButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomTabButton;
@property (weak, nonatomic) IBOutlet UIButton *accessoriesTabButton;
@property (strong, nonatomic) NSMutableDictionary *productContent;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)tabButtonPressed:(id)sender;

- (void)startOperation;

@end


@implementation ProductsViewController

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProductsViewActivityIndicator:nil];
    [self setDressTableViewContainer:nil];
    [self setTopTableViewContainer:nil];
    [self setBottomTableViewContainer:nil];
    [self setAccessoriesTableViewContainer:nil];
    [self setDressTabButton:nil];
    [self setTopTabButton:nil];
    [self setBottomTabButton:nil];
    [self setAccessoriesTabButton:nil];
    
    [dressProductsTableViewController removeFromParentViewController];
    [dressProductsTableViewController.view removeFromSuperview];
    dressProductsTableViewController = nil;
    
    [topProductsTableViewController removeFromParentViewController];
    [topProductsTableViewController.view removeFromSuperview];
    topProductsTableViewController = nil;
    
    [bottomProductsTableViewController removeFromParentViewController];
    [bottomProductsTableViewController.view removeFromSuperview];
    bottomProductsTableViewController = nil;
    
    [accessoriesProductsTableViewController removeFromParentViewController];
    [accessoriesProductsTableViewController.view removeFromSuperview];
    accessoriesProductsTableViewController = nil;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOperation) name:UIApplicationDidBecomeActiveNotification object:nil];

    self.productContent = [[NSMutableDictionary alloc] init];
    [self performSelector:@selector(tabButtonPressed:) withObject:self.dressTabButton];

}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startOperation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.productsTitle setFont:[UIFont fontWithName:@"carnevaleefreakshow.ttf" size:15]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setProductsTitle:nil];
    
    if (self.dressTabButton.isSelected) {
        [topProductsTableViewController removeFromParentViewController];
        [topProductsTableViewController.view removeFromSuperview];
        topProductsTableViewController = nil;
        
        [bottomProductsTableViewController removeFromParentViewController];
        [bottomProductsTableViewController.view removeFromSuperview];
        bottomProductsTableViewController = nil;
        
        [accessoriesProductsTableViewController removeFromParentViewController];
        [accessoriesProductsTableViewController.view removeFromSuperview];
        accessoriesProductsTableViewController = nil;
    }
    else if (self.topTabButton.isSelected){
        [dressProductsTableViewController removeFromParentViewController];
        [dressProductsTableViewController.view removeFromSuperview];
        dressProductsTableViewController = nil;
        
        [bottomProductsTableViewController removeFromParentViewController];
        [bottomProductsTableViewController.view removeFromSuperview];
        bottomProductsTableViewController = nil;
        
        [accessoriesProductsTableViewController removeFromParentViewController];
        [accessoriesProductsTableViewController.view removeFromSuperview];
        accessoriesProductsTableViewController = nil;
    }
    else if (self.bottomTabButton.isSelected) {
        [dressProductsTableViewController removeFromParentViewController];
        [dressProductsTableViewController.view removeFromSuperview];
        dressProductsTableViewController = nil;
        
        [topProductsTableViewController removeFromParentViewController];
        [topProductsTableViewController.view removeFromSuperview];
        topProductsTableViewController = nil;
        
        [accessoriesProductsTableViewController removeFromParentViewController];
        [accessoriesProductsTableViewController.view removeFromSuperview];
        accessoriesProductsTableViewController = nil;
    }
    else if (self.accessoriesTabButton.isSelected) {
        [dressProductsTableViewController removeFromParentViewController];
        [dressProductsTableViewController.view removeFromSuperview];
        dressProductsTableViewController = nil;
        
        [topProductsTableViewController removeFromParentViewController];
        [topProductsTableViewController.view removeFromSuperview];
        topProductsTableViewController = nil;
        
        [bottomProductsTableViewController removeFromParentViewController];
        [bottomProductsTableViewController.view removeFromSuperview];
        bottomProductsTableViewController = nil;
    }
    
    
    
    

    
    
}

- (void)startOperation
{
    [self.productsViewActivityIndicator startAnimating];
    [self.productsViewActivityIndicator setHidden:NO];
    NSURL *url = [NSURL URLWithString:@"http://www.interapppluz.com/apps-cms/locoo/app/products.php"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"%@",json);
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self.productContent removeAllObjects];
            [self.productContent addEntriesFromDictionary:json];
            [dressProductsTableViewController didReceiveProductsinfo:[self.productContent objectForKey:@"Dress"]];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Error Occured!" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [self.productsViewActivityIndicator stopAnimating];
        [self.productsViewActivityIndicator setHidden:YES];

        
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        
        [self.productsViewActivityIndicator stopAnimating];
        [self.productsViewActivityIndicator setHidden:YES];
    }
     ];
    
    [operation start];
    
    

    
}


- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tabButtonPressed:(id)sender {
   

    [self.dressTableViewContainer setHidden:YES];
    [self.topTableViewContainer setHidden:YES];
    [self.bottomTableViewContainer setHidden:YES];
    [self.accessoriesTableViewContainer setHidden:YES];
    
    self.dressTabButton.selected = self.topTabButton.selected = self.bottomTabButton.selected = self.accessoriesTabButton.selected = NO;
    
    if ([sender tag] == 1) {
        if (!dressProductsTableViewController) {
            dressProductsTableViewController = (DressProductsTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RootProductsTableViewController"];
            [self addChildViewController:dressProductsTableViewController];
            dressProductsTableViewController.view.frame = CGRectMake(0, 0, self.dressTableViewContainer.frame.size.width, self.dressTableViewContainer.frame.size.height);
            [self.dressTableViewContainer addSubview:dressProductsTableViewController.view];
            [dressProductsTableViewController didMoveToParentViewController:self];
        }
        [dressProductsTableViewController didReceiveProductsinfo:[self.productContent objectForKey:@"Dress"]];
        [self.dressTableViewContainer setHidden:NO];
        self.dressTabButton.selected = YES;
        
    }
    else if ([sender tag] == 2) {
        if (!topProductsTableViewController) {
            topProductsTableViewController = (TopProductsTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RootProductsTableViewController"];
            [self addChildViewController:topProductsTableViewController];
            topProductsTableViewController.view.frame = CGRectMake(0, 0, self.topTableViewContainer.frame.size.width, self.topTableViewContainer.frame.size.height);
            [self.topTableViewContainer addSubview:topProductsTableViewController.view];
            [topProductsTableViewController didMoveToParentViewController:self];
        }
        [topProductsTableViewController didReceiveProductsinfo:[self.productContent objectForKey:@"Top"]];
        [self.topTableViewContainer setHidden:NO];
        self.topTabButton.selected = YES;
    }
    else if ([sender tag] == 3) {
        if (!bottomProductsTableViewController) {
            bottomProductsTableViewController = (BottomProductsTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RootProductsTableViewController"];
            [self addChildViewController:bottomProductsTableViewController];
            bottomProductsTableViewController.view.frame = CGRectMake(0, 0, self.bottomTableViewContainer.frame.size.width, self.bottomTableViewContainer.frame.size.height);
            [self.bottomTableViewContainer addSubview:bottomProductsTableViewController.view];
            [bottomProductsTableViewController didMoveToParentViewController:self];
        }
        [bottomProductsTableViewController didReceiveProductsinfo:[self.productContent objectForKey:@"Bottom"]];
        [self.bottomTableViewContainer setHidden:NO];
        self.bottomTabButton.selected = YES;
    }
    else if ([sender tag] == 4) {
        if (!accessoriesProductsTableViewController) {
            accessoriesProductsTableViewController = (AccessoriesProductsTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RootProductsTableViewController"];
            [self addChildViewController:accessoriesProductsTableViewController];
            accessoriesProductsTableViewController.view.frame = CGRectMake(0, 0, self.accessoriesTableViewContainer.frame.size.width, self.accessoriesTableViewContainer.frame.size.height);
            [self.accessoriesTableViewContainer addSubview:accessoriesProductsTableViewController.view];
            [accessoriesProductsTableViewController didMoveToParentViewController:self];
        }
        [accessoriesProductsTableViewController didReceiveProductsinfo:[self.productContent objectForKey:@"Accessories"]];
        [self.accessoriesTableViewContainer setHidden:NO];
        self.accessoriesTabButton.selected = YES;
    }
}



@end
