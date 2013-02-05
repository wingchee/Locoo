//
//  AFImageLoadConnection.h


#import <Foundation/Foundation.h>

@protocol AFImageLoadConnectionDelegate;

@interface AFImageLoadConnection : NSObject {
@private
	NSURL* _imageURL;
	NSURLResponse* _response;
	NSMutableData* _responseData;
	NSURLConnection* _connection;
	NSTimeInterval _timeoutInterval;
	
	id<AFImageLoadConnectionDelegate> _delegate;
}

- (id)initWithImageURL:(NSURL*)aURL delegate:(id)delegate;

- (void)start;
- (void)cancel;

@property(nonatomic,readonly) NSData* responseData;
@property(nonatomic,readonly,getter=imageURL) NSURL* imageURL;

@property(nonatomic,retain) NSURLResponse* response;
@property(nonatomic,assign) id<AFImageLoadConnectionDelegate> delegate;

@property(nonatomic,assign) NSTimeInterval timeoutInterval; // Default is 30 seconds

@end

@protocol AFImageLoadConnectionDelegate<NSObject>
- (void)imageLoadConnectionDidFinishLoading:(AFImageLoadConnection *)connection;
- (void)imageLoadConnection:(AFImageLoadConnection *)connection didFailWithError:(NSError *)error;	
@end