//
//  UIImageView+DLBlurredImage.m
//  test
//
//  Created by Aaron on 2016/11/24.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "UIImageView+DLBlurredImage.h"
#import "UIImage+ImageEffects.h"

CGFloat const kDLBlurredImageDefaultBlurRadius            = 20.0;
CGFloat const kDLBlurredImageDefaultSaturationDeltaFactor = 1.8;

@implementation UIImageView (DLBlurredImage)

- (void)setImageToBlur:(UIImage *)image
       completionBlock:(DLBlurredImageCompletionBlock)completion
{
    [self setImageToBlur:image
              blurRadius:kDLBlurredImageDefaultBlurRadius
         completionBlock:completion];
}

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(DLBlurredImageCompletionBlock) completion
{
    [self setImageToBlur:image
              blurRadius:blurRadius
               tintColor:nil
   saturationDeltaFactor:kDLBlurredImageDefaultSaturationDeltaFactor
         completionBlock:completion];
}


- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
             tintColor:(UIColor *)tintColor
 saturationDeltaFactor:(CGFloat)saturationDeltaFactor
       completionBlock:(DLBlurredImageCompletionBlock) completion
{
    [self setImageToBlur:image
              blurRadius:blurRadius
               tintColor:tintColor
   saturationDeltaFactor:saturationDeltaFactor
               maskImage:nil
         completionBlock:completion];
}


- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
             tintColor:(UIColor *)tintColor
 saturationDeltaFactor:(CGFloat)saturationDeltaFactor
             maskImage:(UIImage *)maskImage
       completionBlock:(DLBlurredImageCompletionBlock) completion
{
    NSParameterAssert(image);
    blurRadius = (blurRadius <= 0) ? : kDLBlurredImageDefaultBlurRadius;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:tintColor
                                     saturationDeltaFactor:saturationDeltaFactor
                                                 maskImage:maskImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = blurredImage;
            if (completion) {
                completion();
            }
        });
    });
}



@end
