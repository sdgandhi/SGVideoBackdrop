//
//  UIViewController+SGVideoBackdrop.m
//  Pods
//
//  Created by Sidhant Gandhi on 4/16/15.
//
//

#import "UIViewController+SGVideoBackdrop.h"
#import <objc/runtime.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebimage/UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>

static const NSInteger kSGBackdropVideoViewTag  = 309939562;
static const NSInteger kSGBackdropImageViewTag  = 309939563;
static const NSInteger kSGBackdropBlurViewTag   = 309939564;

@implementation UIViewController (SGVideoBackdrop)
@dynamic sg_videoPlayer;

- (AVPlayer *)sg_videoPlayer {
    __block AVPlayer *player = objc_getAssociatedObject(self, @selector(sg_videoPlayer));
    if (!player) {
        player = [[AVPlayer alloc] init];
        self.sg_videoPlayer = player;
    }
    return player;
}

- (void)setSg_videoPlayer:(AVPlayer *)player {
    objc_setAssociatedObject(self, @selector(sg_videoPlayer), player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sg_setBackdropVideo:(NSURL *)url {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.view.backgroundColor = [UIColor blackColor];
        
        // Don't mess with background audio
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
        
        // Set up player
        if (!self.sg_videoPlayer) {
            self.sg_videoPlayer = [[AVPlayer alloc] init];
        }
        
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kSGBackdropImageViewTag];
        UIView *videoView = [self.view viewWithTag:kSGBackdropVideoViewTag];
        imageView.hidden = YES;
        videoView.hidden = NO;
        if (!videoView) {
            videoView = [[UIView alloc] initWithFrame:self.view.bounds];
            videoView.tag = kSGBackdropVideoViewTag;
            AVPlayerLayer *playerLayer =[AVPlayerLayer playerLayerWithPlayer:self.sg_videoPlayer];
            [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [playerLayer setFrame:[[UIScreen mainScreen] bounds]];
            [videoView.layer addSublayer:playerLayer];
            
            [self.view insertSubview:videoView atIndex:0];
        }

        [self sg_setupBlurForView:videoView];
        
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *item =[[AVPlayerItem alloc]initWithAsset:asset];
        [self.sg_videoPlayer replaceCurrentItemWithPlayerItem:item];
        
        //Config player
        [self.sg_videoPlayer seekToTime:kCMTimeZero];
        [self.sg_videoPlayer setVolume:0.0f];
        [self.sg_videoPlayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sg_playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sg_startVideoPlayer)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        [self sg_startVideoPlayer];
    });
}

- (void)sg_setBackdropImage:(NSURL *)url isGif:(BOOL)gif {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.view.backgroundColor = [UIColor blackColor];
        
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kSGBackdropImageViewTag];
        UIView *videoView = [self.view viewWithTag:kSGBackdropVideoViewTag];
        imageView.hidden = NO;
        videoView.hidden = YES;
        if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = kSGBackdropImageViewTag;
            [self.view insertSubview:imageView atIndex:0];
        }
        
        if (gif) {

            // If we've cached it
            if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:url.absoluteString]) {
                UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
                [imageView setImage:image];
            }
            
            // If we haven't cached it
            else {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    // TODO: Progress
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    if (!error && data) {
                        image = [UIImage sd_animatedGIFWithData:data];
                        [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:data forKey:url.absoluteString toDisk:YES];
                        [imageView setImage:image];
                    }
                }];
            }
            
        } else {
            [imageView sd_setImageWithURL:url];
        }
        
        [self sg_setupBlurForView:imageView];
    });
}

- (UIVisualEffectView *)sg_setupBlurForView:(UIView *)view {
    UIVisualEffectView *blurView = (UIVisualEffectView *)[self.view viewWithTag:kSGBackdropBlurViewTag];
    if (!blurView) {
        blurView = [UIVisualEffectView.alloc initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blurView.frame = self.view.bounds;
        blurView.tag = kSGBackdropBlurViewTag;
        [self.view insertSubview:blurView aboveSubview:view];
    }
    return blurView;
}

- (void)sg_startVideoPlayer {
    [self.sg_videoPlayer play];
}

- (void)sg_playerItemDidReachEnd:(NSNotification *)notification {
    [self.sg_videoPlayer seekToTime:kCMTimeZero];
}

@end
