//
//  PromotionViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/17/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "PromotionViewController.h"
#import "AFNetworking.h"
#import "PromotionTableCell.h"
#import "PromotionContentViewController.h"

@interface PromotionViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *promotionTableView;
@property (strong, nonatomic) NSMutableArray *promotionContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *promotionActivityIndicator;


- (IBAction)backButtonPressed:(id)sender;

@end

@implementation PromotionViewController

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.promotionContent = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOperation) name:UIApplicationDidBecomeActiveNotification object:nil];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self startOperation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startOperation
{
    [self.promotionActivityIndicator startAnimating];
    [self.promotionActivityIndicator setHidden:NO];
    
    NSURL *url = [NSURL URLWithString:@"http://www.interapppluz.com/apps-cms/locoo/app/promotions.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            if ([json objectForKey:@"Promotions"] != nil) {

                [self.promotionContent removeAllObjects];
                [self.promotionContent addObjectsFromArray:[json objectForKey:@"Promotions"]];
                [self.promotionTableView reloadData];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Error Occured!" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            [self.promotionActivityIndicator stopAnimating];
            [self.promotionActivityIndicator setHidden:YES];

        }
        
                
                
                
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        
        [self.promotionActivityIndicator stopAnimating];
        [self.promotionActivityIndicator setHidden:YES];
    }
                                         ];
    
    [operation start];
    

}


- (void)viewDidUnload {
    [self setPromotionTableView:nil];
    [self setPromotionActivityIndicator:nil];
    [super viewDidUnload];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([[segue identifier] isEqualToString:@"PromotionContentSegue"]){
        PromotionContentViewController *vc = [segue destinationViewController];
        NSInteger selectedIndex = [[self.promotionTableView indexPathForSelectedRow] row];
        [vc setPromotionContent: [self.promotionContent objectAtIndex:selectedIndex]];
    }
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.promotionContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromotionTableCell *cell = (PromotionTableCell *)[tableView dequeueReusableCellWithIdentifier: @"PromotionTableCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:bgColorView];
    
    if ([[self.promotionContent objectAtIndex:[indexPath row]] isKindOfClass:[NSDictionary class]]) {

    NSDictionary *content  = [self.promotionContent objectAtIndex:[indexPath row]];
    [cell.promotionThumbnailImage setImageWithURL:[NSURL URLWithString:[content valueForKey:@"thumbnail"]]];
    [cell.titleLabel setText:[content valueForKey:@"title"]];
    [cell.descLabel setText:[content valueForKey:@"description"]];
        [cell.descLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:13.0]];
        [cell.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:15.0]];

    int i = [[content valueForKey:@"expired"]intValue];
    if ( i == 1) {
        [cell.expiredLabel setHidden:YES];
    }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
