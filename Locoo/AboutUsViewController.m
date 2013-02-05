//
//  AboutUsViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/1/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//



#import "AboutUsViewController.h"
#import "ASIHTTPRequest.h"

int blankPixel;
@interface AboutUsViewController ()


@property (strong, nonatomic) NSMutableArray *contentArray;
@property (strong, nonatomic) NSMutableArray *contactArray;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) NSString *link;


- (IBAction)backButtonPressed:(id)sender;

@end

@implementation AboutUsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentArray = [[NSMutableArray alloc] init];
    self.contactArray = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOperation) name:UIApplicationDidBecomeActiveNotification object:nil];
    CGRect currentScreen = [[UIScreen mainScreen] bounds];
    blankPixel = currentScreen.size.height - 190;
    
    self.contentScrollView.contentSize = CGSizeMake(260, 480);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self startOperation];
    
}

- (void)startOperation
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSLog(@"%@",json);
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        [self.contentArray removeAllObjects];
        [self.contentArray addObjectsFromArray:[json objectForKey:@"about-text"]];
        [self.contactArray removeAllObjects];
        [self.contactArray addObjectsFromArray:[json objectForKey:@"contact-information"]];
        [self contentSetup];
        
        
        
    }
    
}




- (void)BackgroundSetup
{
    
    int height = self.contentScrollView.contentSize.height - blankPixel - 132 - 395;
    int i = height/132;
    NSLog(@"%i, %i", height, i);
    if (height%132 != 0) {
        i++;
        
    }
    
    UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentScrollView.contentSize.width, self.contentScrollView.contentSize.height)];
    for(int n = 0; n <= i - 1; n++)
    {
        if (n == i-1) {
                      UIImageView *endimageView = [[UIImageView alloc] init];
            [endimageView setImage:[UIImage imageNamed:@"content-background-end.png"]];
            endimageView.frame = CGRectMake(0, (n*133)+blankPixel + 132 + 395,260, 14);
            [background addSubview:endimageView];
            
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImage:[UIImage imageNamed:@"content-background.png"]];
            imageView.frame = CGRectMake(0, (n*133)+blankPixel + 132 + 395,260, 133);
            [background addSubview:imageView];
        }
        
    }
    
    [self.contentScrollView addSubview:background];
    [self.contentScrollView sendSubviewToBack:background];
}


- (void)contentSetup
{
    NSLog(@"contentSetup");
    for (UIView *subview in self.contentScrollView.subviews) {
        [subview removeFromSuperview];
    }
    //NSLog(@"%f,%f",self.contentScrollView.contentSize.width,self.contentScrollView.contentSize.height);
    self.contentScrollView.contentSize = self.contentScrollView.frame.size;
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"content-aboutus.png"]];
    imageView.frame = CGRectMake(0, blankPixel,260, 527);
    [self.contentScrollView addSubview:imageView];
    
    //int contentcount = [self.contentArray count];
    int contactcount = [self.contactArray count];
    [self.contentScrollView setContentSize:(CGSizeMake(260, 527 + blankPixel))];

    /*
    for(int n = 1; n <= contentcount; n++){
        
        
        NSDictionary *content  = [self.contentArray objectAtIndex:n-1];
        NSString *desc =[content valueForKey:@"description"];
        NSString *title = [content valueForKey:@"title"];
        UIView *contentView = [self contentViewSetupWithFrame:CGRectMake(0, self.contentScrollView.contentSize.height, 260, 50) withTitle:title withDesc:desc];
        [self.contentScrollView addSubview:contentView];
        CGFloat scrollViewHeight = self.contentScrollView.contentSize.height + contentView.frame.size.height;
        
        [self.contentScrollView setContentSize:(CGSizeMake(260, scrollViewHeight))];
    }
    */
    for(int n = 1; n <= contactcount; n++){
        
        
        NSDictionary *content  = [self.contactArray objectAtIndex:n-1];
        NSString *title = [content valueForKey:@"name"];
        NSString *contactUs = [content valueForKey:@"phone"];
        NSString *address =[content valueForKey:@"address"];
        NSString *website = [content valueForKey:@"website"];
        UIView *contactView = [self contactViewSetupWithFrame:CGRectMake(0, self.contentScrollView.contentSize.height, 260, 140) withTitle:title andContactUs:contactUs andAddress:address andWebsite:website];
        [self.contentScrollView addSubview:contactView];
        CGFloat scrollViewHeight = self.contentScrollView.contentSize.height + contactView.frame.size.height;
        
        [self.contentScrollView setContentSize:(CGSizeMake(260, scrollViewHeight))];
    }
    
    
    
    [self BackgroundSetup];
}







- (UIView *)contentViewSetupWithFrame:(CGRect)frame withTitle:(NSString *)title withDesc:(NSString *)desc
{
    UIView *contentView = [[UIView alloc]initWithFrame:frame];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(51, 8, 154, 21)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.text = title;
    [contentView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, 220, 1000)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:15.0f];
    descLabel.text = desc;
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedLabelSize = [desc sizeWithFont:descLabel.font
                                constrainedToSize:descLabel.frame.size
                                    lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f,%f",expectedLabelSize.width,expectedLabelSize.height);
    
    CGRect newFrame = descLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    descLabel.frame = newFrame;
    descLabel.numberOfLines = 0;
    [descLabel sizeToFit];
    
    [contentView addSubview:descLabel];
    
    newFrame = contentView.frame;
    newFrame.size.height += expectedLabelSize.height + 10;
    contentView.frame = newFrame;
    
    return contentView;
    
}


- (UIView *)contactViewSetupWithFrame:(CGRect)frame withTitle:(NSString *)title andContactUs:(NSString *)contactUs andAddress:(NSString *)address andWebsite:(NSString *)website
{
    UIView *contactView = [[UIView alloc]initWithFrame:frame];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"branch-title.png"]];
    imageView.frame = CGRectMake(16, 7,229, 48);
    [contactView addSubview:imageView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 20, 125, 21)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [contactView addSubview:titleLabel];
    
    UIButton *contactUsButton = [[UIButton alloc]initWithFrame:CGRectMake(38, 60, 156, 33)];
    contactUsButton.userInteractionEnabled = YES;
    [contactUsButton setImage:[UIImage imageNamed:@"btn-telephone.png"] forState:UIControlStateNormal];
    [contactUsButton setTitle:@"  CONTACT US:" forState:UIControlStateNormal];
    [contactUsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactUsButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [contactUsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [contactUsButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    contactUsButton.showsTouchWhenHighlighted = YES;
    contactUsButton.tag = 101;
    [contactView addSubview:contactUsButton];
    [contactUsButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];


    
    UILabel *contactUsLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 74, 159, 21)];
    contactUsLabel.backgroundColor = [UIColor clearColor];
    contactUsLabel.font = [UIFont systemFontOfSize:10.0f];
    contactUsLabel.text = contactUs;
    [contactUsLabel setTextAlignment:NSTextAlignmentLeft];
    [contactUsLabel sizeToFit];
    [contactView addSubview:contactUsLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 108, 159, 1000)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont systemFontOfSize:10.0f];
    addressLabel.text = address;
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedLabelSize = [address sizeWithFont:addressLabel.font
                                   constrainedToSize:addressLabel.frame.size
                                       lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame = addressLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    addressLabel.frame = newFrame;
    addressLabel.numberOfLines = 0;
    [addressLabel sizeToFit];
    [contactView addSubview:addressLabel];
    
    
    
    UIButton *addressButton = [[UIButton alloc]initWithFrame:CGRectMake(38, 94, 190, 21+expectedLabelSize.height)];
    addressButton.userInteractionEnabled = YES;
    [addressButton setImage:[UIImage imageNamed:@"btn-address.png"] forState:UIControlStateNormal];
    [addressButton setTitle:@"  ADDRESS:" forState:UIControlStateNormal];
    [addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addressButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [addressButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [addressButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    addressButton.showsTouchWhenHighlighted = YES;
    addressButton.tag = 102;
    [contactView addSubview:addressButton];
    [addressButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *websiteButton = [[UIButton alloc]initWithFrame:CGRectMake(38, addressButton.frame.origin.y + addressButton.frame.size.height + 5, 156, 33)];
    websiteButton.userInteractionEnabled = YES;
    [websiteButton setImage:[UIImage imageNamed:@"btn-email.png"] forState:UIControlStateNormal];
    [websiteButton setTitle:@"  WEBSITE:" forState:UIControlStateNormal];
    [websiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [websiteButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [websiteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [websiteButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    websiteButton.showsTouchWhenHighlighted = YES;
    websiteButton.tag = 103;
    [contactView addSubview:websiteButton];
    [websiteButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    
    UILabel *websiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, addressButton.frame.origin.y + addressButton.frame.size.height + 19, 159, 21)];
    websiteLabel.backgroundColor = [UIColor clearColor];
    websiteLabel.font = [UIFont systemFontOfSize:10.0f];
    websiteLabel.text = website;
    [websiteLabel setTextAlignment:NSTextAlignmentLeft];
    [websiteLabel sizeToFit];
    [contactView addSubview:websiteLabel];
    
    newFrame = contactView.frame;
    newFrame.size.height += expectedLabelSize.height +110;
    
    contactView.frame = newFrame;
    
    return contactView;
    
}


- (IBAction)buttonPressed:(id)sender
{
    NSInteger tid = ((UIControl *) sender).tag;
    NSDictionary *content  = [self.contactArray objectAtIndex:0];
    NSString *contactUs = [content valueForKey:@"phone"];
    NSString *website = [content valueForKey:@"website"];
    
    if (tid == 101) {
        self.link =[NSString stringWithFormat:@"tel://%@", contactUs];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call?"  message:contactUs delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Call", nil];
    [alert show];
    }
    if (tid == 102) {
        self.link = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=Paradigm+Mall,Malaysia"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Maps?"  message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Map", nil];
        [alert show];
    }
    if (tid == 103) {
        self.link = website;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open in Safari?"  message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Safari", nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.link]];
	}
	
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end




