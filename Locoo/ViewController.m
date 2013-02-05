//
//  ViewController.m
//  Locoo
//
//  Created by Lim Wing Chee on 9/28/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import "ViewController.h"
#import "AboutUsViewController.h"
#import "AFNetworking.h"
#import "KGDiscreetAlertView.h"


@interface ViewController ()
{
    int fadingPhotoCount;
    NSMutableArray *fadingPhotoLinkArray;
    NSMutableArray *photoLinkArray;
    UIImage *fadingPhotoHolder;
    __weak IBOutlet UIImageView *fadingPhotoImageView;
    NSTimer *fadingTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)pushButtonPressed:(id)sender;
@end

@implementation ViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self startOperation];
    fadingPhotoLinkArray = [[NSMutableArray alloc] init];
    photoLinkArray = [[NSMutableArray alloc] init];
    
    NSString *path =
    [[NSBundle mainBundle] pathForResource:@"fading0" ofType:@"png" inDirectory:@""];
    NSString *path1 =
    [[NSBundle mainBundle] pathForResource:@"fading1" ofType:@"png" inDirectory:@""];
    NSString *path2 =
    [[NSBundle mainBundle] pathForResource:@"fading2" ofType:@"png" inDirectory:@""];
    
    [fadingPhotoLinkArray addObject:path];
    [fadingPhotoLinkArray addObject:path1];
    [fadingPhotoLinkArray addObject:path2];
    BOOL fileExists;
    int i = 0;
    do {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fading%d.png", i]];
        
        fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
        if(fileExists) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSLog(@"deleted");
            [fileManager removeItemAtPath: fullPath error:NULL];
        }
        i++;

    } while (fileExists);
    
    
    fadingPhotoHolder =[UIImage imageWithContentsOfFile:fadingPhotoLinkArray[0]];
    
    fadingPhotoCount = 0;
  
    
}

- (void)startOperation
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.interapppluz.com/apps-cms/locoo/app/gallery.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            if ([[json objectForKey:@"Images"]count]!=0) {
                
                [photoLinkArray removeAllObjects];
                [photoLinkArray addObjectsFromArray:[json objectForKey:@"Images"]];
                [self performSelectorInBackground:@selector(linkToPath) withObject:nil];
            }
            [fadingTimer fire];
            
        }

    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        [KGDiscreetAlertView showDiscreetAlertWithText:@"No internet connection"
                                                inView:self.view];
    }
                                         ];
    
    [operation start];
    
}





-(void)transitionPhotos{

    
    if (fadingPhotoCount < [fadingPhotoLinkArray count] - 1){
        fadingPhotoCount ++;
    }else{
        fadingPhotoCount = 0;
    }
    
    [UIView transitionWithView:fadingPhotoImageView
                      duration:2.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ fadingPhotoImageView.image = fadingPhotoHolder; }
                    completion:NULL];
    
    //fadingPhotoHolder = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:fadingPhotoLinkArray[fadingPhotoCount]]]];
    
    fadingPhotoHolder =[UIImage imageWithContentsOfFile:fadingPhotoLinkArray[fadingPhotoCount]];
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.navigationController navigationBar] setHidden:YES];
    fadingTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(transitionPhotos) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    fadingPhotoImageView = nil;
    
    [self setBackgroundImageView:nil];
    [fadingTimer invalidate];
    [super viewDidUnload];
}


- (IBAction)pushButtonPressed:(id)sender {
    [fadingTimer invalidate];
}


- (void)linkToPath{
    
    NSMutableArray *pathArray = [[NSMutableArray alloc]init];
    for (int i = 0; i <= [photoLinkArray count] - 1; i++) {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoLinkArray[i]]]];
        
        [self saveImage:image withImageName:[NSString stringWithFormat:@"%d",i+3]];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fading%d.png", i+3]];
        if (image != NULL) {
            [pathArray addObject:fullPath];
        }
    }
    [fadingPhotoLinkArray addObjectsFromArray:pathArray];
    
    
}





- (void)saveImage:(UIImage*)image withImageName:(NSString*)imageName {
    
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fading%@.png", imageName]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
        
}



@end
