//
//  VideoViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/12/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "VideoViewController.h"
#import "AFNetworking.h"
#import "VideoTableCell.h"
#import "PSYouTubeExtractor.h"


@interface VideoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    PSYouTubeExtractor *extractor_;
    int i;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *videoActivityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@property (strong, nonatomic) NSMutableArray *videoContent;
@property (strong, nonatomic) NSString *videolink;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *videoTableViewActivityIndicator;
@property (strong, nonatomic) MPMoviePlayerController *controller;


- (void)startOperation;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation VideoViewController

- (void)dealloc
{
    [extractor_ cancel];
    [self.controller stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setVideoTableView:nil];
    [self setVideoActivityIndicator:nil];
    [self setVideoImage:nil];
    [self setVideoTableViewActivityIndicator:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.presentingViewController.class isKindOfClass:VideoViewController.class])
    {
        NSLog(@"testing");
    }
    
    self.videoContent = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOperation) name:UIApplicationDidBecomeActiveNotification object:nil];
    i = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotificationPause:)
                                                 name:@"MPMoviePlayerPause"
                                               object:nil];
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutViewForOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
     
 	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.videoActivityIndicator setHidden:YES];
    [self startOperation];

}





- (void)startOperation
{
    //[self.productsViewActivityIndicator startAnimating];
    [self.videoTableViewActivityIndicator startAnimating];
    [self.videoTableViewActivityIndicator setHidden:NO];
    NSURL *url = [NSURL URLWithString:@"http://interapppluz.com/apps-cms/locoo/app/videos.php"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {

        
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            if ([json objectForKey:@"Videos"] != nil) {
                
                [self.videoContent removeAllObjects];
                [self.videoContent addObjectsFromArray:[json objectForKey:@"Videos"]];
                [self.videoTableView reloadData];
                [self.videoTableView.delegate tableView:self.videoTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Video!" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Error Occured!" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }    
        [self.videoTableViewActivityIndicator stopAnimating];
        [self.videoTableViewActivityIndicator setHidden:YES];
     
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        [self.videoTableViewActivityIndicator stopAnimating];
        [self.videoTableViewActivityIndicator setHidden:YES];
    }
                                         ];
    
    [operation start];
    

}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [extractor_ cancel];


}

- (void)videoButtonPressed {


    
   extractor_ = [PSYouTubeExtractor extractorForYouTubeURL:[NSURL URLWithString:self.videolink] success:^(NSURL *URL) {
       
        self.controller = [[MPMoviePlayerController alloc] initWithContentURL:URL];
       [self.controller prepareToPlay];
       [self.controller.view setFrame: self.videoImage.frame];
        self.controller.scalingMode = MPMovieScalingModeAspectFit;
     
       [self.view addSubview:self.controller.view];
       [self.controller play];
 
        [self.videoActivityIndicator stopAnimating];
       [self.videoActivityIndicator setHidden:YES];

       
    } failure:^(NSError *error) {
        NSLog(@"error");
        [self.videoActivityIndicator stopAnimating];
        [self.videoActivityIndicator setHidden:YES];

     
    }];
    
}


- (void)receiveTestNotificationPause
{
    [self.controller pause];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videoContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableCell *cell = (VideoTableCell *)[tableView dequeueReusableCellWithIdentifier: @"VideoTableCell"];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:bgColorView];
    if ([[self.videoContent objectAtIndex:[indexPath row]] isKindOfClass:[NSDictionary class]]) {
    NSDictionary *content  = [self.videoContent objectAtIndex:[indexPath row]];
        [cell.videoThumbnailImage setImageWithURL:[NSURL URLWithString:[content valueForKey:@"thumbnail"]]];
    [cell.titleLabel setText:[content valueForKey:@"title"]];
     [cell.descLabel setText:[content valueForKey:@"description"]];
        [cell.descLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:13.0]];
        [cell.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:15.0]];

    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (i!=[indexPath row]) {
        [self.videoActivityIndicator startAnimating];
        [self.videoActivityIndicator setHidden:NO];
        
        [self.controller stop];
    [extractor_ cancel];
    NSDictionary *content  = [self.videoContent objectAtIndex:[indexPath row]];

    if ([content valueForKey:@"youtube"] != nil) {
    self.videolink = [content valueForKey:@"youtube"];
       }
    i = [indexPath row];
    [self videoButtonPressed];
}
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



- (void)layoutViewForOrientation:(NSNotification *)notification
{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        if (!self.controller.isFullscreen) {
            [UIView animateWithDuration:0.5
                                  delay:0
                                options: UIViewAnimationCurveEaseOut
                             animations:^{
                                 [self.controller setFullscreen:YES];
                             }
                             completion:nil];
        }
    }
    else if (orientation == UIInterfaceOrientationPortrait)
    {
        if (self.controller.isFullscreen) {
            [UIView animateWithDuration:0.5
                                  delay:0
                                options: UIViewAnimationCurveEaseOut
                             animations:^{
                                 [self.controller setFullscreen:NO];
                             }
                             completion:nil];
        }
    }
    

}




@end
