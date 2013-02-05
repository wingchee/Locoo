//
//  ModelController.m
//  Rimmel London
//
//  Created by Peter Chew on 25/8/12.
//  Copyright (c) 2012 InterApp Pluz Sdn. Bhd. All rights reserved.
//

#import "ModelController.h"
#import "AppDelegate.h"
#import "Favourite.h"

@interface ModelController () {
    NSFetchRequest *fetchRequest;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation ModelController
@synthesize managedObjectContext;

+ (id)sharedManager
{
    static ModelController *controller;
    if (controller == nil) {
        controller = [[self alloc] init];
    }
    return controller;
}

- (id)init
{
    self = [super init];
    if (self) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = delegate.managedObjectContext;
        delegate = nil;
    }
    return self;
}

- (void)deleteFavouritewithContent:(NSDictionary *)content
{
    for (Favourite *obj in [self favouriteCategoryDataAtCategory]) {
        if ([obj.productID isEqualToString:[content valueForKey:@"id"]]) {
            [self.managedObjectContext deleteObject:obj];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail%@.png",[content valueForKey:@"id"]]];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
            if (fileExists)
                [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            
            fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@.png",[content valueForKey:@"id"]]];
            fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
            if (fileExists)
                [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            
        }
    

    }
}

- (BOOL)hasAddedContent:(NSDictionary *)content
{
    BOOL addIntoModel = NO;;
    for (Favourite *obj in [self favouriteCategoryDataAtCategory]) {
        if ([obj.productID isEqualToString:[content valueForKey:@"id"]]) {
            addIntoModel = YES;
        }
    }
    return addIntoModel;
}

- (void)addFavouriteEntrywithContent:(NSDictionary *)content
{
    
    
        Favourite *fav = [NSEntityDescription insertNewObjectForEntityForName:@"Favourite" inManagedObjectContext:self.managedObjectContext];
        fav.code = [content valueForKey:@"code"];
        fav.price = [content valueForKey:@"price"];
        fav.descriptions = [content valueForKey:@"description"];
        fav.imagePath = [content valueForKey:@"imagePath"];
        fav.productID = [content valueForKey:@"id"];
        fav.thumbnailPath = [content objectForKey:@"thumbnailPath"];
        fav.title = [content valueForKey:@"title"];
        fav.image = [content valueForKey:@"image"];
        fav.thumbnail = [content valueForKey:@"thumbnail"];

    
    
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    NSLog(@"%@",error.localizedDescription);
        if (error == NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favourite Added Successfully" message:@"Successfully added into favourites" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Adding Favourites" message:@"Internal Error Occured." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    

- (NSArray *)favouriteCategoryDataAtCategory
{
    if (fetchRequest == nil) {
        fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setFetchBatchSize:1000];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Favourite" inManagedObjectContext:self.managedObjectContext]];
        
      //  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
      //  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    //NSLog(@"%@",[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]);

 //   for (Favourite *fav in [self.managedObjectContext executeFetchRequest:fetchRequest error:nil]) {
  //      NSLog(@"%@",fav.thumbnailPath);
  //  }
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}


@end
