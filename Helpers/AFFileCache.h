//
//  AFFileCache.h
//  
//
//  Created by PCX
//  Copyright 2010 AppsFactory. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFFileCache : NSObject {
	NSArray *data;
	NSString *keyword;
}
- (id)initWithKeyword:(NSString *)key;
- (void)saveData:(NSArray *)dataIn;
- (NSArray *)getData;
- (NSString *)filePath;

@end
