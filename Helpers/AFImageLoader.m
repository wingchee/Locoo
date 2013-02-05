//
//  AFImageLoader.m


#import "AFImageLoader.h"
#import "AFImageLoadConnection.h"
#import "AFCache.h"

static AFImageLoader* __imageLoader;

inline static NSString* keyForURL(NSURL* url) {
	return [NSString stringWithFormat:@"AFImageLoader-%u", [[url description] hash]];
}

#define kImageNotificationLoaded(s) [@"kAFImageLoaderNotificationLoaded-" stringByAppendingString:keyForURL(s)]
#define kImageNotificationLoadFailed(s) [@"kAFImageLoaderNotificationLoadFailed-" stringByAppendingString:keyForURL(s)]

@implementation AFImageLoader
@synthesize currentConnections=_currentConnections;

+ (AFImageLoader*)sharedImageLoader {
	@synchronized(self) {
		if(!__imageLoader) {
			__imageLoader = [[[self class] alloc] init];
		}
	}
	
	return __imageLoader;
}

- (id)init {
    self = [super init];
	if(self) {
		connectionsLock = [[NSLock alloc] init];
		currentConnections = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (AFImageLoadConnection*)loadingConnectionForURL:(NSURL*)aURL {
	AFImageLoadConnection* connection = [[self.currentConnections objectForKey:aURL] retain];
	if(!connection) return nil;
	else return [connection autorelease];
}

- (void)cleanUpConnection:(AFImageLoadConnection*)connection {
	if(!connection.imageURL) return;
	
	connection.delegate = nil;
	
	[connectionsLock lock];
	[currentConnections removeObjectForKey:connection.imageURL];
	self.currentConnections = [[currentConnections copy] autorelease];
	[connectionsLock unlock];	
}

- (BOOL)isLoadingImageURL:(NSURL*)aURL {
	return [self loadingConnectionForURL:aURL] ? YES : NO;
}

- (void)cancelLoadForURL:(NSURL*)aURL {
	AFImageLoadConnection* connection = [self loadingConnectionForURL:aURL];
	[NSObject cancelPreviousPerformRequestsWithTarget:connection selector:@selector(start) object:nil];
	[connection cancel];
	[self cleanUpConnection:connection];
}

- (void)loadImageForURL:(NSURL*)aURL observer:(id<AFImageLoaderObserver>)observer {
	if(!aURL) return;
	
	if([observer respondsToSelector:@selector(imageLoaderDidLoad:)]) {
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(imageLoaderDidLoad:) name:kImageNotificationLoaded(aURL) object:self];
	}
	
	if([observer respondsToSelector:@selector(imageLoaderDidFailToLoad:)]) {
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(imageLoaderDidFailToLoad:) name:kImageNotificationLoadFailed(aURL) object:self];
	}
	
	if([self loadingConnectionForURL:aURL]) {
		return;
	}
	
	AFImageLoadConnection* connection = [[AFImageLoadConnection alloc] initWithImageURL:aURL delegate:self];

	[connectionsLock lock];
	[currentConnections setObject:connection forKey:aURL];
	self.currentConnections = [[currentConnections copy] autorelease];
	[connectionsLock unlock];
	[connection performSelector:@selector(start) withObject:nil afterDelay:0.01];
	[connection release];
}

- (UIImage*)imageForURL:(NSURL*)aURL shouldLoadWithObserver:(id<AFImageLoaderObserver>)observer {
	if(!aURL) return nil;
	
	UIImage* anImage = [[AFCache currentCache] imageForKey:keyForURL(aURL)];
	
	if(anImage) {
		return anImage;
	} else {
		[self loadImageForURL:(NSURL*)aURL observer:observer];
		return nil;
	}
}

- (BOOL)hasLoadedImageURL:(NSURL*)aURL {
	return [[AFCache currentCache] hasCacheForKey:keyForURL(aURL)];
}

- (void)removeObserver:(id<AFImageLoaderObserver>)observer {
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:nil object:self];
}

- (void)removeObserver:(id<AFImageLoaderObserver>)observer forURL:(NSURL*)aURL {
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:kImageNotificationLoaded(aURL) object:self];
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:kImageNotificationLoadFailed(aURL) object:self];
}

#pragma mark -
#pragma mark URL Connection delegate methods

- (void)imageLoadConnectionDidFinishLoading:(AFImageLoadConnection *)connection {
	UIImage* anImage = [UIImage imageWithData:connection.responseData];
	
	if(!anImage) {
		NSError* error = [NSError errorWithDomain:[connection.imageURL host] code:406 userInfo:nil];
		NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(connection.imageURL)
																	 object:self
																   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",connection.imageURL,@"imageURL",nil]];
		
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
	} else {
		[[AFCache currentCache] setData:connection.responseData forKey:keyForURL(connection.imageURL) withTimeoutInterval:604800];
		
		[currentConnections removeObjectForKey:connection.imageURL];
		self.currentConnections = [[currentConnections copy] autorelease];
		
		NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoaded(connection.imageURL)
																	 object:self
																   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:anImage,@"image",connection.imageURL,@"imageURL",nil]];
		
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
	}

	[self cleanUpConnection:connection];
}

- (void)imageLoadConnection:(AFImageLoadConnection *)connection didFailWithError:(NSError *)error {
	[currentConnections removeObjectForKey:connection.imageURL];
	self.currentConnections = [[currentConnections copy] autorelease];
	
	NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(connection.imageURL)
																 object:self
															   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",connection.imageURL,@"imageURL",nil]];
	
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];

	[self cleanUpConnection:connection];
}

#pragma mark -

- (void)dealloc {
	self.currentConnections = nil;
	[currentConnections release];
	[connectionsLock release];
	[super dealloc];
}

@end