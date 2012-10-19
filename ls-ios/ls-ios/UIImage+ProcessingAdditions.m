//
//  UIImage+ProcessingAdditions.m
//  ls-ios
//
//  Created by Aaron Crespo on 10/18/12.
//  Copyright (c) 2012 Aaron Crespo. All rights reserved.
//

#import "UIImage+ProcessingAdditions.h"
#import <OpenGLES/EAGL.h>

@implementation UIImage(ProcessingAdditions)
- (UIImage*)sepia
{
    CIImage *startImage = [CIImage imageWithCGImage:[self CGImage]];
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //ignore color space for performance
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
    
    //hw accelerate it, for more performance decrease context creation.
    CIContext *context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, startImage,
                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    return newImg;
}
@end
