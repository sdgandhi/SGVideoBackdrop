//
//  UIImageView+GIFCache.m
//  Pods
//
//  Created by Sidhant Gandhi on 4/17/15.
//
//

#import "UIImageView+GIFCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebimage/UIImage+GIF.h>

@implementation UIImageView (GIFCache)

- (void)sg_setImageWithGIFUrl:(NSURL *)url {
    // If we've cached it
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:url.absoluteString]) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
        [self setImage:image];
    }
    
    // If we haven't cached it
    else {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // TODO: Progress
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (!error && data) {
                image = [UIImage sd_animatedGIFWithData:data];
                [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:data forKey:url.absoluteString toDisk:YES];
                [self setImage:image];
            }
        }];
    }
}

@end
