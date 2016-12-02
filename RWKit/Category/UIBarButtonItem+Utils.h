//
//  UIBarButtonItem+Utils.h
//  DevelopmentDietSystem
//
//  Created by RangerChiong on 16/12/2.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Utils)

+ (instancetype)itemWithTarget:(id)target button:(void (^)(UIButton *sender))block action:(SEL)action;

+ (instancetype)itemWithButton:(void (^)(UIButton *button))block action:(void (^)(UIButton *sender))action;

@end

NS_ASSUME_NONNULL_END
