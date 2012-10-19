//
//  LSParseOperation.m
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import "LSParseOperation.h"

@implementation LSParseOperation 
@synthesize errorHandler = _errorHandler;

- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler
{
    self = [super init];
    if (self != nil)
    {
        dataToParse = data;
        self.completionHandler = handler;
    }
    return self;
}

- (void) main
{
    NSError *error = nil;
    NSArray *collection = @[];
    if (dataToParse) {
        collection = [NSJSONSerialization JSONObjectWithData:dataToParse options:kNilOptions error:&error];
    }

    if (error) {
        self.errorHandler(error);
    }
    
    if (!self.isCancelled) {
        self.completionHandler(collection);
    }
}
@end
