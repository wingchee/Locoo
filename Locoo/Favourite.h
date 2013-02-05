//
//  Favourite.h
//  Locoo
//
//  Created by Lim Wing Chee on 1/8/13.
//  Copyright (c) 2013 Lim Wing Chee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favourite : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * productID;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * thumbnailPath;

@end
