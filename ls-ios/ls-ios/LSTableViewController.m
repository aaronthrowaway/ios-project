//
//  ViewController.m
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSTableViewCell.h"
#import "UIImage+ProcessingAdditions.h"

@interface LSTableViewController ()
{
    NSCache *_imageCache;
}
@end

@implementation LSTableViewController

@synthesize entries = _entries;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
    }
	int count = self.entries.count;
	
	// if there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        count = round(self.view.frame.size.height/[LSTableViewCell cellHeight]);
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"LSCell";
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        LSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
		{
            cell = [[LSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:CellIdentifier];
            [cell prepareForReuse];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.desc.text = @"Loading…";
        cell.attrib.text = @"Loading…";
        cell.userName.text = @"Loading…";
		
		return cell;
    }
	
    LSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[LSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier];
        [cell prepareForReuse];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        NSDictionary *post = self.entries[indexPath.row];
        cell.desc.text = post[@"desc"];
        cell.attrib.text = post[@"attrib"];
        cell.userName.text = post[@"user"][@"username"];
        id imageSrc = post[@"src"];
        id avatarSrc = post[@"user"][@"avatar"][@"src"];
        
        // Only load cached images; defer new downloads until scrolling ends image
        if (![_imageCache objectForKey:imageSrc])
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:imageSrc forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.image.image = [UIImage imageNamed:@"LivingSocial.png"];
        }
        else{
            cell.image.image = [_imageCache objectForKey:imageSrc];
        }
        
        //avatar
        if (![_imageCache objectForKey:avatarSrc])
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:avatarSrc forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.avatar.image = [UIImage imageNamed:@"LivingSocial.png"];
        }
        else{
            cell.avatar.image = [_imageCache objectForKey:avatarSrc];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSString *)urlString forIndexPath:(NSIndexPath *)indexPath
{
    LSImageFetcher *imageFetcher = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageFetcher == nil)
    {
        imageFetcher = [[LSImageFetcher alloc] init];
        imageFetcher.imageURL = [NSURL URLWithString:urlString];
        imageFetcher.tablePath = indexPath;
        imageFetcher.delegate = self;
        [self.imageDownloadsInProgress setObject:imageFetcher forKey:indexPath];
        [imageFetcher startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSDictionary *post = self.entries[indexPath.row];
            id imageSrc = post[@"src"];
            id avatarSrc = post[@"user"][@"avatar"][@"src"];

            if (![_imageCache objectForKey:imageSrc])
            {
                [self startIconDownload:imageSrc forIndexPath:indexPath];
            }
            if (![_imageCache objectForKey:avatarSrc])
            {
                [self startIconDownload:avatarSrc forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath;
{
    LSImageFetcher *imageFetcher = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageFetcher != nil && imageFetcher.image)
    {
        LSTableViewCell *cell = (LSTableViewCell *)[self.tableView cellForRowAtIndexPath:imageFetcher.tablePath];
        NSString *urlStr = imageFetcher.imageURL.absoluteString;

        if ([urlStr rangeOfString:@"avatar" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            cell.avatar.image = imageFetcher.image;
            [_imageCache setObject:cell.avatar.image forKey:imageFetcher.imageURL.absoluteString];
        } else {
            cell.image.image = [imageFetcher.image sepia];
            [_imageCache setObject:cell.image.image forKey:imageFetcher.imageURL.absoluteString];
        }
    }
    
    // Remove the Downloader from the in progress list.
    [self.imageDownloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma IBActions
-(IBAction)goToWebpage:(id)sender
{
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {        
        CGPoint location = [(UITapGestureRecognizer *)sender locationInView:self.tableView];
        NSDictionary *post = self.entries[[self.tableView indexPathForRowAtPoint:location].row];
        NSString *url = post[@"href"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
