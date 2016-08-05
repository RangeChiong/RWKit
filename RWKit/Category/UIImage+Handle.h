//
//  UIImage+Handle.h
//  UIImageBlurEffectCategory
//
//  Created by Ranger on 16/8/5.
//  Copyright © 2016年 Vincent Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Handle)

#pragma mark-  blur effect

- (UIImage *)rw_applyingLightEffect;
- (UIImage *)rw_applyingExtraLightEffect;
- (UIImage *)rw_applyingDarkEffect;
- (UIImage *)rw_applyingTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)rw_applyingBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
