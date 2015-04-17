//
//  UIViewController+SGVideoBackdrop.h
//  Pods
//
//  Created by Sidhant Gandhi on 4/16/15.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIViewController (SGVideoBackdrop)

@property (nonatomic, strong) AVPlayer *sg_videoPlayer;

- (void)sg_setBackdropVideo:(NSURL *)url;
- (void)sg_setBackdropImage:(NSURL *)url isGif:(BOOL)gif;

@end
