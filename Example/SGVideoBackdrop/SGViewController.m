//
//  SGViewController.m
//  SGVideoBackdrop
//
//  Created by Sidhant Gandhi on 04/16/2015.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//
//  GIF Images from: http://www.wired.com/2013/09/the-rise-of-subtle-tasteful-and-commissioned-animated-gif-illustrations/

#import "SGViewController.h"

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SGVideoBackdrop" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSURL *videoUrl = [bundle URLForResource:@"xx" withExtension:@"mp4"];

    [self sg_setBackdropImage:[NSURL URLWithString:@"http://www.wired.com/wp-content/uploads/images_blogs/design/2013/09/davey1_1.gif"] isGif:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sg_setBackdropVideo:videoUrl];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sg_setBackdropImage:[NSURL URLWithString:@"http://www.wired.com/wp-content/uploads/images_blogs/design/2013/09/davey1_1.gif"] isGif:YES];

    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
