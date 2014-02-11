//
//  ViewController.m
//  Example
//
//  Created by amacou on 2014/02/11.
//  Copyright (c) 2014年 amacou. All rights reserved.
//

#import "ViewController.h"
#import "YAPGif.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // image from http://ja.wikipedia.org/wiki/%E3%83%91%E3%82%A4%E3%83%AB%E3%83%89%E3%83%A9%E3%82%A4%E3%83%90%E3%83%BC
    NSString *path = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YAPGif *gif = [[YAPGif alloc] initWithGifData:data];
    self.imageView.image = gif.image;
    NSMutableArray *images = [NSMutableArray array];
    
    //cc by taki http://photozou.jp/photo/list/221844/6233186
    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByDeletingLastPathComponent] error:nil];
    for (NSString *fileName in list) {
        if ([[fileName pathExtension] isEqualToString:@"jpg"]) {
            [images addObject:[UIImage imageNamed:fileName]];
        }
    }
    
    
    YAPGif *gif2 = [[YAPGif alloc]initWithImages:images];
    gif2.seconds = [NSNumber numberWithFloat:2.0f];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [gif2 exportWithPath:[docPath stringByAppendingPathComponent:@"animation.gif"]];
    
    [self.webView loadHTMLString:@"<html>\n<style>\nimg{width:100%}\n</style>\n</body>\n<img src=\'animation.gif\'>\n</body></html>" baseURL:[NSURL fileURLWithPath:docPath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
