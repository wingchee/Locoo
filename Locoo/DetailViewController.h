//
//  DetailViewController.h
//  Locoo
//
//  Created by Lim Wing Chee on 9/28/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
