//
//  AppDelegate.h
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTableViewController.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, retain) NSURLConnection     *feedConnection;
@property (nonatomic, retain) NSMutableData       *feedData;
@property (nonatomic, retain) NSMutableArray      *feedRecords;

@property (nonatomic, retain) NSOperationQueue    *queue;
@end
