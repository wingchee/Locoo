//
//  FBShareViewController.m
//  12FLY Newsstand
//
//  Created by Peter Chew on 21/9/12.
//  Copyright (c) 2012 InterApp Pluz Sdn. Bhd. All rights reserved.
//

#import "FBShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImageView+AFNetworking.h"

@interface FBShareViewController () <UITextViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (strong, nonatomic) NSMutableDictionary *postParams;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
- (void)resetPostMessage;

@end

@implementation FBShareViewController

NSString *const kPlaceholderPostMessage = @"Say something about this...";

- (void)dealloc
{
    [self.postParams removeAllObjects];
    
    self.delegate = nil;
}

- (id)initWithParams:(NSDictionary *)params
{
    self = [super initWithNibName:@"FBShareViewController_iPhone" bundle:nil];
    if (self) {
        
        if (params != nil) {
            self.postParams = [params mutableCopy];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.postNameLabel setFont:[UIFont fontWithName:kFONT_MYRIAD_PRO_BOLD size:15]];
    [self.postCaptionLabel setFont:[UIFont fontWithName:kFONT_MYRIAD_PRO_BOLD size:11]];
    [self.postDescriptionLabel setFont:[UIFont fontWithName:kFONT_MYRIAD_PRO_REGULAR size:12]];
    [self.postMessageTextView setFont:[UIFont fontWithName:kFONT_MYRIAD_PRO_REGULAR size:14]];
    [self resetPostMessage];
    
    self.postNameLabel.text = [self.postParams objectForKey:kFBSHARE_NAME_KEY];
    self.postCaptionLabel.text = [self.postParams objectForKey:kFBSHARE_CAPTION_KEY];  [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams objectForKey:kFBSHARE_DESC_KEY]; [self.postDescriptionLabel sizeToFit];
    
    [self.postImageView setImageWithURL:[NSURL URLWithString:[self.postParams objectForKey:kFBSHARE_PICTURE_KEY]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (![self.view.window isKeyWindow]) {
        self.postMessageTextView = nil;
        self.postImageView = nil;
        self.postNameLabel = nil;
        self.postCaptionLabel = nil;
        self.postDescriptionLabel = nil;
        self.view = nil;
    }
}

- (void)viewDidUnload
{
    [self setPostMessageTextView:nil];
    [self setPostImageView:nil];
    [self setPostNameLabel:nil];
    [self setPostCaptionLabel:nil];
    [self setPostDescriptionLabel:nil];
    [super viewDidUnload];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender
{
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }

    if (![self.postMessageTextView.text isEqualToString:kPlaceholderPostMessage] && ![self.postMessageTextView.text isEqualToString:@""]) {
        [self.postParams setObject:self.postMessageTextView.text forKey:kFBSHARE_MESSAGE_KEY];
    }
    [self.delegate fbShareViewControllerShareFBDialogWithParams:self.postParams withController:self];
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}


#pragma UITextView Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}
@end
