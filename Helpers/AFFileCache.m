//
//  AFFileCache.m
// 
//
//  Created by PCX
//  Copyright 2010 AppsFactory. All rights reserved.
//

#import "AFFileCache.h"


@implementation AFFileCache

- (id)initWithKeyword:(NSString *)key {
	self = [super init];
    if (self) {
		keyword = [[NSString alloc] initWithFormat:@"%@.cah", key];
		NSString *path = [self filePath];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:path])
			data = [[NSArray alloc] initWithContentsOfFile:path];
		else
			data = [[NSArray alloc] init];
	}
	return self;
}

- (NSString *)filePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:keyword];
}

- (void)saveData:(NSArray *)dataIn {
    NSLog(@"%@", [self filePath]);
//	[dataIn writeToFile:[self filePath] atomically:YES];
    
}

- (NSArray *)getData {
	return data;
}


@end
