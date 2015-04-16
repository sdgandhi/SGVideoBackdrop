//
//  SGViewController.m
//  SGVideoBackdrop
//
//  Created by Sidhant Gandhi on 04/16/2015.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import "SGViewController.h"

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self sg_setBackdropVideo:[NSURL URLWithString:@"https://ia801408.us.archive.org/27/items/sample_video_clip_Shark_swim_240/Shark_clip4_240_1_512kb.mp4"]];
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
