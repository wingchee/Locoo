//
//  ProductsContentViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 10/3/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "ProductsContentViewController.h"
#import "AFImageView.h"
#import "AppDelegate.h"
#import "ShareViewController.h"
#import "ModelController.h"
#import "AFImageLoader.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"


@interface ProductsContentViewController () <FBLoginViewDelegate>

- (IBAction)favouriteButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)handleProductsDetailView:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *productsContentView;
@property (strong, nonatomic) NSDictionary *productInfo;
@property (weak, nonatomic) IBOutlet UILabel *productCode;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;
@property (weak, nonatomic) IBOutlet UIImageView *pageTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *buttonActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;




@end

@implementation ProductsContentViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buttonActivityIndicator setHidden:YES];
    if(self.pageTitleImage)
        [self.pageTitle setImage:self.pageTitleImage];
    if ([self.productContent valueForKey:@"imagepath"] != nil) {
        [self.productImage setImage:[UIImage imageWithContentsOfFile:[self.productContent valueForKey:@"imagepath"]]];
    }
    else
    {
        [self.productImage setImageWithURL:[NSURL URLWithString:[self.productContent valueForKey:@"image"]]];
    }
        
    [self.productPrice setText:[self.productContent valueForKey:@"price"]];
    [self.productDesc setText:[self.productContent valueForKey:@"description"]];
    [self.productCode setText:[self.productContent valueForKey:@"code"]];
    [self.productPrice setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17.0]];
    [self.productDesc setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:13.0]];
    [self.productCode setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:20.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favouriteButtonPressed:(id)sender {
    
    
    [self.buttonActivityIndicator startAnimating];
    [self.favouriteButton setHidden:YES];
    [self.buttonActivityIndicator setHidden:NO];
    
    
    
    BOOL added =[[ModelController sharedManager] hasAddedContent:self.productContent];

    if (added) {
    
        [[ModelController sharedManager] deleteFavouritewithContent:self.productContent];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favourite Deleted Successfully" message:@"Successfully deleted from favourites" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        if (!self.pageTitleImage) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self.buttonActivityIndicator stopAnimating];
        [self.favouriteButton setHidden:NO];
        [self.buttonActivityIndicator setHidden:YES];
    }
    else{
        [self performSelectorInBackground:@selector(saveContent) withObject:nil];
    
    }

}

-(void)saveContent
{
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:self.productContent];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@.png",[self.productContent valueForKey:@"id"]]];
    
    
    UIImage *image = [[UIImageView alloc] cachedImageRequestForURL:[NSURL URLWithString:[self.productContent valueForKey:@"image"]]];
  
    if (image != nil) {
        [self saveImage:image withImageName:[NSString stringWithFormat:@"image%@.png",[self.productContent valueForKey:@"id"]]];
        [temp setValue:fullPath forKey:@"imagePath"];
    }
   
    
    NSString *tfullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail%@.png",[self.productContent valueForKey:@"id"]]];
    UIImage *timage =[[UIButton alloc] cachedImageRequestForURL:[NSURL URLWithString:[self.productContent valueForKey:@"thumbnail"]]];
   
    
    if (timage != nil) {
        [self saveImage:timage withImageName:[NSString stringWithFormat:@"thumbnail%@.png",[self.productContent valueForKey:@"id"]]];
        [temp setValue:tfullPath forKey:@"thumbnailPath"];
    }
    [[ModelController sharedManager] addFavouriteEntrywithContent:temp];
    [self.buttonActivityIndicator stopAnimating];
    [self.favouriteButton setHidden:NO];
    [self.buttonActivityIndicator setHidden:YES];
    
}

- (IBAction)handleProductsDetailView:(id)sender{
    
    int up = self.view.frame.size.height/2;
    int down = 420;
    UIGestureRecognizer *recognizer = (UIGestureRecognizer *)sender;
    if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)recognizer;
        
        if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.productsContentView.frame;
                rect.origin = CGPointMake(0, up);
                self.productsContentView.frame = rect;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.productsContentView.frame;
                rect.origin = CGPointMake(0, down);
                self.productsContentView.frame = rect;
            }];
        }
    }
    
    else{
        CGRect rect = self.productsContentView.frame;
        if (rect.origin.y==down) {
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.productsContentView.frame;
                rect.origin = CGPointMake(0, up);
                self.productsContentView.frame = rect;
            }];
        }
        else{
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.productsContentView.frame;
                rect.origin = CGPointMake(0, down);
                self.productsContentView.frame = rect;
            }];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setProductsContentView:nil];
    [self setProductCode:nil];
    [self setProductPrice:nil];
    [self setProductImage:nil];
    [self setProductDesc:nil];
    [self setPageTitle:nil];
    [self setButtonActivityIndicator:nil];
    [self setFavouriteButton:nil];
    [super viewDidUnload];
}



- (IBAction)shareButtonPressed:(id)sender {
    
    
   
    
    BOOL displayedNativeDialog =
    [FBNativeDialogs
     presentShareDialogModallyFrom:self
     initialText:[self.productContent valueForKey:@"code"]
     image:self.productImage.image
     url:[NSURL URLWithString:@"http://www.facebook.com/locooshop"]
     handler:^(FBNativeDialogResult result, NSError *error) {
         if (error && [error code] == 7) {
             return;
         }
         
         NSString *alertText = @"";
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else if (result == FBNativeDialogResultSucceeded) {
             alertText = @"Posted successfully.";
         }
         if (![alertText isEqualToString:@""]) {
             // Show the result in an alert
             [[[UIAlertView alloc] initWithTitle:@"Result"
                                         message:alertText
                                        delegate:self
                               cancelButtonTitle:@"OK!"
                               otherButtonTitles:nil]
              show];
         }
         
     }];
    if (!displayedNativeDialog) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];

          }
}
- (void)sessionStateChanged:(NSNotification*)notification
{
    if (FBSession.activeSession.isOpen) {
        
        // and here we make sure to update our UX according to the new session state
        ShareViewController *viewController = [[ShareViewController alloc]
                                               initWithNibName:@"ShareViewController"
                                               bundle:nil];
        [viewController setShareDictionary:self.productContent];
        
        [self presentViewController:viewController animated:YES completion:nil];

    }
}


- (void)saveImage:(UIImage*)image withImageName:(NSString*)imageName {
    
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent: imageName]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    
}



@end
