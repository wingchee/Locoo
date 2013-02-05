//
//  VideoTableCell.h
//  Locoo
//
//  Created by Lim Wing Chee on 10/12/12.
//  Copyright (c) 2012 Lim Wing Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface VideoTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoCellBg;

@end
