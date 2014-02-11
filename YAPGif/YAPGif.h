//
//  YAPGif.h
//  YAPGif
//
//  Created by amacou on 2014/02/10.
//  Copyright (c) 2014年 amacou.
//  This software is released under the MIT License, see LICENSE
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YAPGif : NSObject
- (instancetype)initWithImages:(NSArray *)images;
- (instancetype)initWithGifData:(NSData *)data;
- (void)exportWithPath:(NSString *)path;
- (NSData *)data;
- (UIImage *)image;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, strong) NSNumber *delay;
@property (nonatomic, strong) NSNumber *seconds;

@end
