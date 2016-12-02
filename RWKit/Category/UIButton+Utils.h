//
//  UIButton+Utils.h
//  Zeughaus
//
//  Created by 常小哲 on 16/4/23.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Utils)

- (void)rw_setNormalTitle:(NSString *)title;
- (void)rw_setNormalTitle:(NSString *)title titleColor:(nullable UIColor *)titleColor;

- (void)rw_setSelectedTitle:(NSString *)title;
- (void)rw_setSelectedTitle:(NSString *)title titleColor:(nullable UIColor *)titleColor;

- (void)rw_addTarget:(id)target action:(SEL)action;
- (void)rw_actionforTouchUpInsideUsingBlock:(void (^)(UIButton *sender))block;
- (void)rw_actionforControlEvents:(UIControlEvents)controlEvents usingBlock:(void (^)(UIButton *sender))block;

- (void)rw_startCountdown:(NSInteger)time;

@end

NS_ASSUME_NONNULL_END
