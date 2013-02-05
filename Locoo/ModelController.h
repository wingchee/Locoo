//
//  ModelController.h
//
//  Created by Peter Chew on 25/8/12.
//  Copyright (c) 2012 InterApp Pluz Sdn. Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelController : NSObject {
    
}
+ (id)sharedManager;

- (void)addFavouriteEntrywithContent:(NSDictionary *)content;
- (NSArray *)favouriteCategoryDataAtCategory;
- (void)deleteFavouritewithContent:(NSDictionary *)content;
- (BOOL)hasAddedContent:(NSDictionary *)content;

@end
