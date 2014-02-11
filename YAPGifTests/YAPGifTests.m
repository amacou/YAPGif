//
//  YAPGifTests.m
//  YAPGifTests
//
//  Created by amacou on 2014/02/10.
//  Copyright (c) 2014年 amacou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "YAPGif.h"
@interface YAPGifTests : XCTestCase
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *dirPath;
@end

@implementation YAPGifTests

- (void)setUp
{
    [super setUp];
    self.images = [NSMutableArray array];
    NSString *path = [NSString stringWithUTF8String:__FILE__];
    self.dirPath = [path stringByDeletingLastPathComponent];
    path = [self.dirPath stringByAppendingPathComponent:@"images"];
    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *file_name in list) {
        if ([[file_name pathExtension] isEqualToString:@"jpg"]) {
            NSString *file_path = [path stringByAppendingPathComponent:file_name];
            UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:file_path]];
            [self.images addObject:image];
        }
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithImages
{
    YAPGif *gif = [[YAPGif alloc] initWithImages:self.images];

    XCTAssertTrue((gif != nil), @"init");
    XCTAssertTrue(([gif.images count] == 18), @"images length");
    XCTAssertTrue((gif.size.width == 624 && gif.size.height == 416), @"size");
    XCTAssertEqualObjects(gif.delay,@0.06f, @"fps is not default value");
    XCTAssertEqualObjects(gif.seconds,@1.08f, @"secounds is not total time");//0.06f * 18
}

- (void)testInitWithGifData
{
    NSData *data = [NSData dataWithContentsOfFile:[self.dirPath stringByAppendingPathComponent:@"animation.gif"]];
    YAPGif *gif = [[YAPGif alloc] initWithGifData:data];
    
    XCTAssertTrue((gif != nil), @"init");
    XCTAssertTrue(([gif.images count] == 18), @"images length");
    XCTAssertTrue((gif.size.width == 624 && gif.size.height == 416), @"size");
    XCTAssertEqualObjects(gif.delay, @0.06f, @"fps is not default value");
    XCTAssertEqualObjects(gif.seconds, @1.08f, @"secounds is not total time");//0.06f * 18
}

- (void)testData
{
    YAPGif *gif = [[YAPGif alloc] initWithImages:self.images];
    NSData *data = [gif data];
    XCTAssertTrue(([data length] > 10000), @"data is not nil");
}

- (void)testExport
{
    YAPGif *gif = [[YAPGif alloc] initWithImages:self.images];
    NSString *path = [self.dirPath stringByAppendingPathComponent:@"animation.gif"];
    [gif exportWithPath:path];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path],@"export file doesn't exist");
}

- (void)testImage
{
    YAPGif *gif = [[YAPGif alloc] initWithImages:self.images];
    UIImage *image = [gif image];
    XCTAssertTrue(([image isKindOfClass:[UIImage class]]),@"class is not UIImage");
    XCTAssertTrue((CGSizeEqualToSize(image.size, gif.size)),@"size");
}
@end
