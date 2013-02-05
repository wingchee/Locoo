//
//  AFImageButton.h
//  
//
//  Created by PCX
//  Copyright 2010 AppsFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFImageLoader.h"

@protocol AFImageButtonDelegate;
@interface AFImageButton : UIButton<AFImageLoaderObserver> {
@private
	NSURL* imageURL;
	UIImage* placeholderImage;
	UIActivityIndicatorView *activity;
	id<AFImageButtonDelegate> delegate;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<AFImageButtonDelegate>)aDelegate;

- (void)cancelImageLoad;

@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,retain) id<AFImageButtonDelegate> delegate;
@end

@protocol AFImageButtonDelegate<NSObject>
@optional
- (void)imageButtonLoadedImage:(AFImageButton*)imageButton;
- (void)imageButtonFailedToLoadImage:(AFImageButton*)imageButton error:(NSError*)error;
@end