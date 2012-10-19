//
//  LSImageFetcher.h
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

@protocol LSImageFetcherDelegate;

@interface LSImageFetcher : NSObject

@property (nonatomic, retain) UIImage           *image;
@property (nonatomic, retain) NSURL             *imageURL;
@property (nonatomic, retain) NSIndexPath       *tablePath;
@property (nonatomic, assign) id<LSImageFetcherDelegate> delegate;
@property (nonatomic, retain) NSMutableData     *activeDownload;
@property (nonatomic, retain) NSURLConnection   *imageConnection;

- (void)startDownload;
- (void)cancelDownload;
@end

@protocol LSImageFetcherDelegate

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end