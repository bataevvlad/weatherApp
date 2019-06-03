//
//  UIImageView+DLBlurredImage.h
//  test
//
//  Created by Aaron on 2016/11/24.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DLBlurredImageCompletionBlock)(void);

@interface UIImageView (DLBlurredImage)

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(DLBlurredImageCompletionBlock)completion;

- (void)setImageToBlur:(UIImage *)image
       completionBlock:(DLBlurredImageCompletionBlock)completion;

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
             tintColor:(UIColor *)tintColor
 saturationDeltaFactor:(CGFloat)saturationDeltaFactor
       completionBlock:(DLBlurredImageCompletionBlock) completion;

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
             tintColor:(UIColor *)tintColor
 saturationDeltaFactor:(CGFloat)saturationDeltaFactor
             maskImage:(UIImage *)maskImage
       completionBlock:(DLBlurredImageCompletionBlock) completion;


@end
