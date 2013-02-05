//
//  RootViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 12/18/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) shouldAutorotate
{
    return YES;
}


-(NSUInteger)supportedInterfaceOrientations
{

  //  return [self.presentingViewController isKindOfClass:VideoViewController.class ] ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait;
}





@end
