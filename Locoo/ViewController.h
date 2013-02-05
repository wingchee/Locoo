//
//  ViewController.h
//  Locoo
//
//  Created by Lim Wing Chee on 9/28/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *testVIew;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


@end
