//
//  UIBarButtonItem+Utils.m
//  DevelopmentDietSystem
//
//  Created by RangerChiong on 16/12/2.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "UIBarButtonItem+Utils.h"
#import "UIButton+Utils.h"

@implementation UIBarButtonItem (Utils)

+ (instancetype)itemWithTarget:(id)target button:(void (^)(UIButton *sender))block action:(SEL)action {
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    !sender ?: sender(itemButton);
    [itemButton rw_addTarget:target action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    return item;
}

+ (instancetype)itemWithButton:(void (^)(UIButton *button))block action:(void (^)(UIButton *sender))action {
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    !button ?: button(itemButton);
    [itemButton rw_actionforTouchUpInsideUsingBlock:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    return item;
}

@end
