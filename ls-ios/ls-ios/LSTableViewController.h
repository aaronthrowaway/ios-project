//
//  ViewController.h
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSImageFetcher.h"

@interface LSTableViewController : UITableViewController <UITableViewDelegate, LSImageFetcherDelegate>
@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end
