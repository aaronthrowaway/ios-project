//
//  LSParseOperation.h
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

typedef void (^ArrayBlock)(NSArray *);
typedef void (^ErrorBlock)(NSError *);

@interface LSParseOperation : NSOperation
{
    NSData *dataToParse;
}

@property (nonatomic, copy) ErrorBlock errorHandler;
@property (nonatomic, copy) ArrayBlock completionHandler;

- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler;
@end
