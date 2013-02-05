//
//  AFImageView.h

#import <UIKit/UIKit.h>
#import "AFImageLoader.h"

@protocol AFImageViewDelegate;
@interface AFImageView : UIImageView<AFImageLoaderObserver> {
@private
	NSURL* imageURL;
	UIImage* placeholderImage;
	UIActivityIndicatorView *activity;
	id<AFImageViewDelegate> delegate;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<AFImageViewDelegate>)aDelegate;

- (void)cancelImageLoad;

@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,retain) id<AFImageViewDelegate> delegate;

- (UIImage *)getImage;

@end

@protocol AFImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImage:(AFImageView*)imageView;
- (void)imageViewFailedToLoadImage:(AFImageView*)imageView error:(NSError*)error;
@end