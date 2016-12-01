//
//  UIImage+Handle.h
//  UIImageBlurEffectCategory
//
//  Created by Ranger on 16/8/5.
//  Copyright © 2016年 Vincent Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Handle)

#pragma mark-  改变图片颜色
- (UIImage *)rw_renderColor:(UIColor *)color;
#pragma mark-  剪裁图片
- (UIImage *)rw_clipImage;

#pragma mark-  blur effect

- (UIImage *)rw_applyingLightEffect;
- (UIImage *)rw_applyingExtraLightEffect;
- (UIImage *)rw_applyingDarkEffect;
- (UIImage *)rw_applyingTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)rw_applyingBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
