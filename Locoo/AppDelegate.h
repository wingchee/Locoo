//
//  AppDelegate.h
//  Locoo
//
//  Created by Lim Wing Chee on 9/28/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "RootViewController.h"
extern NSString *const FBSessionStateChangedNotification;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) RootViewController *navController;
@property (strong, nonatomic) ViewController *viewController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;


@end
