//
//  PromotionContentViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/17/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "PromotionContentViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PromotionContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *expiredLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (weak, nonatomic) IBOutlet UITextView *contentDesc;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;




- (IBAction)backButtonPressed:(id)sender;

@end

@implementation PromotionContentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.promotionContent);
    [self.contentImage setImageWithURL:[NSURL URLWithString:[self.promotionContent valueForKey:@"image"]]];
    [self.contentTitle setText:[self.promotionContent valueForKey:@"title"]];
    [self.contentDesc setText:[self.promotionContent valueForKey:@"description"]];
    int i = [[self.promotionContent valueForKey:@"expired"]intValue];
    if ( i == 1) {
        [self.expiredLabel setHidden:YES];
    }
    [self.contentDesc setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:14.0]];
    [self.contentTitle setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:17.0]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload {
    [self setExpiredLabel:nil];
    [self setContentImage:nil];
    [self setContentTitle:nil];
    [self setContentDesc:nil];
    [self setContentImage:nil];
    [super viewDidUnload];
}
@end
