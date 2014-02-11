//
//  YAPGif.m
//  YAPGif
//
//  Created by amacou on 2014/02/10.
//  Copyright (c) 2014年 amacou.
//  This software is released under the MIT License, see LICENSE
//

#import "YAPGif.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation YAPGif
- (instancetype)initWithImages:(NSArray *)images
{
    if (images == nil ||
        [images count] == 0 ||
        ![images[0] isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.images = images;
        self.delay = @0.06f;
        _size = ((UIImage *)self.images[0]).size;;
    }
    return self;
}

- (instancetype)initWithGifData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        
        size_t count = CGImageSourceGetCount(source);
        NSMutableArray* images = [NSMutableArray array];
        
        NSDecimal duration = [[NSNumber numberWithFloat:0.0f] decimalValue];
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            NSDictionary* frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
            NSDecimal fileduration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] decimalValue];
            NSDecimal result ;
            NSDecimalAdd(&result, &duration, &fileduration, NSRoundPlain);
            duration = result;
            [images addObject:[UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        CFRelease(source);
        
        self.images = images;
        NSNumber *sec = [NSNumber numberWithFloat:[[NSDecimalNumber decimalNumberWithDecimal:duration] floatValue]];
        if ([sec floatValue] > 0){
            self.seconds = sec;
        }else{
            self.seconds = @((1.0f/10.0f) * count);
        }
        _size = ((UIImage *)self.images[0]).size;
    }
    return self;
}


- (void)setSeconds:(NSNumber *)seconds
{
    _seconds = seconds;
    NSDecimal result;
    NSDecimal sec = [self.seconds decimalValue];
    NSDecimal count = [[NSNumber numberWithUnsignedInteger:[self.images count]] decimalValue];
    NSDecimalDivide(&result, &sec, &count, NSRoundPlain);
    _delay = [NSNumber numberWithFloat:[[NSDecimalNumber decimalNumberWithDecimal:result] floatValue]];;
}


- (void)setDelay:(NSNumber *)delay
{
    _delay = delay;
    NSDecimal result;
    NSDecimal del = [self.delay decimalValue];
    NSDecimal count = [[NSNumber numberWithUnsignedInteger:[self.images count]] decimalValue];
    NSDecimalMultiply(&result, &del, &count, NSRoundPlain);
    _seconds = [NSNumber numberWithFloat:[[NSDecimalNumber decimalNumberWithDecimal:result] floatValue]];;
}


- (NSData *)data
{
    NSUInteger frameCount = [self.images count];

    //loop
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0,
                                             }
                                     };

    //delay seounds (float)
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: _delay,
                                              }
                                      };

    NSMutableData* data = [[NSMutableData alloc] init];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, kUTTypeGIF, frameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (NSUInteger i = 0; i < frameCount; i++) {
        @autoreleasepool {
            UIImage *image = self.images[i];
            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    return data;
}

- (void)exportWithPath:(NSString *)path{
    [[self data] writeToFile:path atomically:YES];
}

- (UIImage *)image{
    if (!self.images) {
        return nil;
    }
    return [UIImage animatedImageWithImages:self.images duration:[self.seconds doubleValue]];
}
@end
