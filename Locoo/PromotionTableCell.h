//
//  PromotionTableCell.h
//  Locoo
//
//  Created by Lim Wing Chee on 10/17/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface PromotionTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *expiredLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promotionThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promotionCellBg;
@end
