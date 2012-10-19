//
//  AppDelegate.m
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

static NSString *const LSPinterestFeed = @"http://warm-eyrie-4354.herokuapp.com/feed.json";

#import "LSAppDelegate.h"
#import "LSParseOperation.h"

@interface LSAppDelegate()
{
    IBOutlet LSTableViewController *tableViewController;
}
@end

@implementation LSAppDelegate

@synthesize feedConnection  = _feedConnection;
@synthesize feedData        = _feedData;
@synthesize queue           = _queue;
@synthesize feedRecords     = _feedRecords;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:LSPinterestFeed]];
    self.feedConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    self.feedRecords = @[].mutableCopy;
    tableViewController = (LSTableViewController*)self.window.rootViewController;
    tableViewController.entries = self.feedRecords;
    
    NSAssert(self.feedConnection != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return YES;
}

#pragma mark -
#pragma mark NSURLConnection delegate methods
//method called after a successfull collection request.
- (void)handleCollection:(NSArray *)collection
{
    [self.feedRecords addObjectsFromArray:collection];
    [tableViewController.tableView reloadData];
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"API read/parse/transfer error"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.feedData = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.feedData appendData:data];        // append incoming data
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //stop activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.feedConnection = nil;   // release our connection
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.feedConnection = nil;   // release our connection

    //stop activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // create the queue to run our ParseOperation
    self.queue = [[NSOperationQueue alloc] init];
    
    // create an ParseOperation (NSOperation subclass) to parse json

    LSParseOperation *parser = [[LSParseOperation alloc] initWithData:self.feedData
                                                completionHandler:^(NSArray *appList) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [self handleCollection:appList];
                                                        
                                                    });
                                                    
                                                    self.queue = nil;   // we are finished with the queue and our ParseOperation
                                                }];
    
    parser.errorHandler = ^(NSError *parseError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self handleError:parseError];
            
        });
    };
    
    [self.queue addOperation:parser]; // this will start the "ParseOperation"
    self.feedData = nil;
}

@end
