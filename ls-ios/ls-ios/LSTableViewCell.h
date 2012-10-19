//
//  LSTableViewCell.h
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel       *desc;
@property (nonatomic, retain) IBOutlet UILabel       *attrib;
@property (nonatomic, retain) IBOutlet UIImageView   *image;

@property (nonatomic, retain) IBOutlet UILabel       *usersName;
@property (nonatomic, retain) IBOutlet UILabel       *userName;
@property (nonatomic, retain) IBOutlet UIImageView   *avatar;

+ (CGFloat)cellHeight;
@end
