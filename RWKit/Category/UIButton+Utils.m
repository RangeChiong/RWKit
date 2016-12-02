//
//  UIButton+Utils.m
//  Zeughaus
//
//  Created by 常小哲 on 16/4/23.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "UIButton+Utils.h"
@import ObjectiveC;

static const void *RWButtonActionBlock = &RWButtonActionBlock;

@interface UIButton (RWButtonUtilPrivate)

@property (nonatomic, copy) void (^actionBlock)(UIButton *sender);

@end

@implementation UIButton (Utils)

- (void)rw_setNormalTitle:(NSString *)title {
    [self rw_setNormalTitle:title titleColor:nil];
}

- (void)rw_setNormalTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)rw_setSelectedTitle:(NSString *)title {
    [self rw_setSelectedTitle:title titleColor:nil];
}

- (void)rw_setSelectedTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateSelected];
    }
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)rw_addTarget:(id)target action:(SEL)action {
    NSAssert([target respondsToSelector:action], @"selector & action 必须存在");

    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)rw_actionforTouchUpInsideUsingBlock:(void (^)(UIButton *sender))block {
    [self rw_actionforControlEvents:UIControlEventTouchUpInside usingBlock:block];
}

- (void)rw_actionforControlEvents:(UIControlEvents)controlEvents usingBlock:(void (^)(UIButton *sender))block {
    NSAssert(block, @"block 不能为nil");

    self.actionBlock = block;
    [self addTarget:self action:@selector(pressButtonAction:) forControlEvents:controlEvents];
}

- (void)pressButtonAction:(UIButton *)sender {
    self.actionBlock(sender);
}

- (void)setActionBlock:(void (^)(UIButton *sender))handler {
    objc_setAssociatedObject(self, RWButtonActionBlock, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *sender))actionBlock {
    return objc_getAssociatedObject(self, RWButtonActionBlock);
}

- (void)rw_startCountdown:(NSInteger)time {
    self.enabled = NO;
    
    __block NSInteger timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            });
        }
        else {
            NSInteger seconds = timeout / 1;
            NSString *strTime = [NSString stringWithFormat:@"%lds后重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:strTime forState:UIControlStateDisabled];
                [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            });
            
            timeout--;
        }
    });
    dispatch_resume(timer);
}

@end
