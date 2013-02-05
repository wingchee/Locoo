//
//  AFImageView.m


#import "AFImageView.h"
#import "AFImageLoader.h"

@implementation AFImageView
@synthesize imageURL, placeholderImage, delegate;

- (id)initWithPlaceholderImage:(UIImage*)anImage {
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<AFImageViewDelegate>)aDelegate {
	if((self = [super initWithImage:anImage])) {
		self.placeholderImage = anImage;
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.clipsToBounds = YES;
		self.delegate = aDelegate;
	}
	
	return self;
}

- (UIImage *)getImage {
	return self.image;
}

- (void)setImageURL:(NSURL *)aURL {
	if(imageURL) {
		[[AFImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
	}
	
	if(!aURL) {
		self.image = self.placeholderImage;
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
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
			[self.delegate imageViewLoadedImage:self];
		}
		
		self.image = anImage;
	} else {
		if (activity == nil) {
			activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
			[activity setFrame:CGRectMake((self.frame.size.width - activity.frame.size.width)/2, 
										  (self.frame.size.height - activity.frame.size.height)/2, 
										  activity.frame.size.width, activity.frame.size.height)];
			[activity startAnimating];
			[self addSubview:activity];
			self.image = nil;
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
	self.image = anImage;
	[self setNeedsDisplay];
	
	if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
		[self.delegate imageViewLoadedImage:self];
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
	
	self.image = self.placeholderImage;

	if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
		[self.delegate imageViewFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
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
