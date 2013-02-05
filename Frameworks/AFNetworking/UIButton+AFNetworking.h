//
//  UIButton+AFNetworking.h
//  Delicious
//
//  Created by Peter Chew on 18/12/12.
//  Copyright (c) 2012 InterApp Pluz Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFImageRequestOperation.h"
#import <Availability.h>



@interface UIButton (AFNetworking)

- (void)setImageWithURL:(NSURL *)url;


- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;


- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;


- (void)cancelImageRequestOperation;
-(UIImage *)cachedImageRequestForURL:(NSURL *)url;
@end