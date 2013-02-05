//
//  AFImageButton.m
//  
//
//  Created by PCX
//  Copyright 2010 AppsFactory. All rights reserved.
//
#import "AFImageButton.h"


@implementation AFImageButton
@synthesize imageURL, placeholderImage, delegate;

- (id)initWithPlaceholderImage:(UIImage*)anImage {
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<AFImageButtonDelegate>)aDelegate {
	if((self = [super initWithFrame:CGRectZero])) {
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.clipsToBounds = YES;
		[self setImage:self.placeholderImage forState:UIControlStateNormal];
	}
	
	return self;
}

- (void)setImageURL:(NSURL *)aURL {
	if(imageURL) {
		[[AFImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
	}
	
	if(!aURL) {
		[self setImage:self.placeholderImage forState:UIControlStateNormal];
		imageURL = nil;
		return;
	} else {
		imageURL = [aURL retain];
	}
	[[AFImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[AFImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	
	if(anImage) {
		
		if (activity != nil) {
			if ([activity respondsToSelector:@selector(stopAnimating)]) {
				if ([activity isAnimating]) {
					[activity stopAnimating];
					[activity removeFromSuperview];
					[activity release];
					activity = nil;
				}
			}
		}
		if([self.delegate respondsToSelector:@selector(imageButtonLoadedImage:)]) {
			[self.delegate imageButtonLoadedImage:self];
		}
		[self setImage:anImage forState:UIControlStateNormal];
		
	} else {
		if (activity == nil) {
			activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			[activity setFrame:CGRectMake((self.frame.size.width - activity.frame.size.width)/2, 
										  (self.frame.size.height - activity.frame.size.height)/2, 
										  activity.frame.size.width, activity.frame.size.height)];
			[activity startAnimating];
			[self addSubview:activity];
			[self setImage:nil forState:UIControlStateNormal];
		}
	}
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
	[[AFImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[AFImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if (activity != nil) {
		if ([activity respondsToSelector:@selector(stopAnimating)]) {
			if ([activity isAnimating]) {
				[activity stopAnimating];
				[activity removeFromSuperview];
				[activity release];
				activity = nil;
			}
		}
	}
	
	
	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
	[self setImage:anImage forState:UIControlStateNormal];
	[self setNeedsDisplay];
	
	if([self.delegate respondsToSelector:@selector(imageButtonLoadedImage:)]) {
		[self.delegate imageButtonLoadedImage:self];
	}	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if (activity != nil) {
		if ([activity respondsToSelector:@selector(stopAnimating)]) {
			if ([activity isAnimating]) {
				[activity stopAnimating];
				[activity removeFromSuperview];
				[activity release];
				activity = nil;
			}
		}
	}
	
	[self setImage:self.placeholderImage forState:UIControlStateNormal];
	
	if([self.delegate respondsToSelector:@selector(imageButtonFailedToLoadImage:error:)]) {
		[self.delegate imageButtonFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
	}
}

#pragma mark -
- (void)dealloc {
	[[AFImageLoader sharedImageLoader] removeObserver:self];
	self.imageURL = nil;
	self.placeholderImage = nil;
    [super dealloc];
}

@end
