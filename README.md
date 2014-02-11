YAPGif
======

YAPGif is animation gif library for ios

Create animation gif from UIImage
------
    NSArray *images = @[[UIImage imageNamed:@"foo"],[UIImage imageNamed:@"bar"]];
    YAPGif *gif = [[YAPGif alloc] initWithImages:images];

    //you can change image delay
    //default delay is 0.06f
    gif.deley = [NSNumber numberWithFloat:0.1f];//change seconds automatically

    //or you can change total time
    gif.seconds = [NSNumber numberWithFloat:3.0f];//change delay automatically

    //create gif data
    NSData *data = gif.data;

    //export to a file
    [gif exportWithPath:@"somewhere"];


Create animation image from animation gif
------
    NSData *gifData = [NSData dataWithContentsOfFile:@"path to gif"];
    YAPGif *gif = [[YAPGif alloc] initWithGifData:gifData];

    //create animation image
    UIImage *image = gif.image;

    //show image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];


Using images in Example and Test
----
1. Baseball images by taki from http://photozou.jp/photo/list/221844/6233186
2. Piledriver image from http://ja.wikipedia.org/wiki/%E3%83%91%E3%82%A4%E3%83%AB%E3%83%89%E3%83%A9%E3%82%A4%E3%83%90%E3%83%BC

LICENCE
----------
Copyright &copy; 2014 amacou
Distributed under the [MIT License][mit].
[MIT]: http://www.opensource.org/licenses/mit-license.php
