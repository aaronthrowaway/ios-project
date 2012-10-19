//
//  LSImageFetcher.m
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import "LSImageFetcher.h"
#import "UIImage+ProcessingAdditions.h"

@implementation LSImageFetcher

@synthesize tablePath       = _tablePath;
@synthesize delegate        = _delegate;
@synthesize activeDownload  = _activeDownload;
@synthesize imageConnection = _imageConnection;

#pragma mark

- (void)dealloc
{
    [self.imageConnection cancel];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              self.imageURL] delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    CGSize itemSize = CGSizeMake(200, 200);
    
    UIGraphicsBeginImageContext(itemSize);

    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image  drawInRect:imageRect];
    self.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our image is ready for display
    [self.delegate imageDidLoad:self.tablePath];
}

@end
