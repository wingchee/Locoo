//
//  AFImageLoader.h
//  AFImageLoading
//

#import <Foundation/Foundation.h>

@protocol AFImageLoaderObserver;
@interface AFImageLoader : NSObject/*<NSURLConnectionDelegate>*/ {
@private
	NSDictionary* _currentConnections;
	NSMutableDictionary* currentConnections;
	
	NSLock* connectionsLock;
}

+ (AFImageLoader*)sharedImageLoader;

- (BOOL)isLoadingImageURL:(NSURL*)aURL;
- (void)loadImageForURL:(NSURL*)aURL observer:(id<AFImageLoaderObserver>)observer;
- (UIImage*)imageForURL:(NSURL*)aURL shouldLoadWithObserver:(id<AFImageLoaderObserver>)observer;
- (BOOL)hasLoadedImageURL:(NSURL*)aURL;

- (void)cancelLoadForURL:(NSURL*)aURL;
- (void)imageForURL:(NSURL*)aURL shouldLoadWithObserver:(id<AFImageLoaderObserver>)observer andSavewithImageName:(NSString *)imageName;

- (void)removeObserver:(id<AFImageLoaderObserver>)observer;
- (void)removeObserver:(id<AFImageLoaderObserver>)observer forURL:(NSURL*)aURL;

@property(nonatomic,retain) NSDictionary* currentConnections;
@end

@protocol AFImageLoaderObserver<NSObject>
@optional
- (void)imageLoaderDidLoad:(NSNotification*)notification; // Object will be AFImageLoader, userInfo will contain imageURL and image
- (void)imageLoaderDidFailToLoad:(NSNotification*)notification; // Object will be AFImageLoader, userInfo will contain error
@end