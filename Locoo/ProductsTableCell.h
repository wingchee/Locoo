//
//  ProductsTableCell.h
//  Locoo
//
//  Created by Lim Wing Chee on 10/1/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+AFNetworking.h"

@interface ProductsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *productImageButton1;
@property (weak, nonatomic) IBOutlet UIButton *productImageButton2;
@property (weak, nonatomic) IBOutlet UIImageView *productImageFrame2;

@end
