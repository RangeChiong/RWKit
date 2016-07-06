//
//  UIView+EasyShow.m
//  RPAntus
//
//  Created by Crz on 15/11/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "UIView+EasyShow.h"

@implementation UIView (EasyShow)

- (void)setRw_x:(CGFloat)rw_x {
    CGRect frame = self.frame;
    frame.origin.x = rw_x;
    self.frame = frame;
}

- (CGFloat)rw_x {
    return self.frame.origin.x;
}

- (void)setRw_left:(CGFloat)rw_x {
    [self setRw_x:rw_x];
}

- (CGFloat)rw_left {
    return self.frame.origin.x;
}

- (void)setRw_maxX:(CGFloat)rw_maxX {
    self.rw_x = rw_maxX - self.rw_width;
}

- (CGFloat)rw_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setRw_right:(CGFloat)rw_maxX {
    [self setRw_maxX:rw_maxX];
}

- (CGFloat)rw_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setRw_maxY:(CGFloat)rw_maxY {
    self.rw_y = rw_maxY - self.rw_height;
}

- (CGFloat)rw_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setrw_bottom:(CGFloat)rw_maxY {
    [self setRw_maxY:rw_maxY];
}

- (CGFloat)rw_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setRw_y:(CGFloat)rw_y {
    CGRect frame = self.frame;
    frame.origin.y = rw_y;
    self.frame = frame;
}

- (CGFloat)rw_y {
    return self.frame.origin.y;
}

- (void)setRw_top:(CGFloat)rw_y {
    [self setRw_y:rw_y];
}

- (CGFloat)rw_top {
    return self.frame.origin.y;
}

- (void)setRw_centerX:(CGFloat)rw_centerX {
    CGPoint center = self.center;
    center.x = rw_centerX;
    self.center = center;
}

- (CGFloat)rw_centerX {
    return self.center.x;
}

- (void)setRw_centerY:(CGFloat)rw_centerY {
    CGPoint center = self.center;
    center.y = rw_centerY;
    self.center = center;
}

- (CGFloat)rw_centerY {
    return self.center.y;
}

- (void)setRw_width:(CGFloat)rw_width {
    CGRect frame = self.frame;
    frame.size.width = rw_width;
    self.frame = frame;
}

- (CGFloat)rw_width {
    return self.frame.size.width;
}

- (void)setRw_height:(CGFloat)rw_height {
    CGRect frame = self.frame;
    frame.size.height = rw_height;
    self.frame = frame;
}

- (CGFloat)rw_height {
    return self.frame.size.height;
}

- (void)setRw_origin:(CGPoint)rw_origin {
    CGRect frame = self.frame;
    frame.origin = rw_origin;
    self.frame = frame;
}

- (CGPoint)rw_origin {
    return self.frame.origin;
}

- (void)setRw_size:(CGSize)rw_size {
    CGRect frame = self.frame;
    frame.size = rw_size;
    self.frame = frame;
}

- (CGSize)rw_size {
    return self.frame.size;
}

- (void)setRw_cornerRadius:(CGFloat)rw_cornerRadius {
    self.layer.cornerRadius = rw_cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)rw_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)rw_round {
    [self setCornerRadius:self.frame.size.height/2];
}

@end

#pragma mark-  XibHelper

@implementation UIView (XibHelper)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}



- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}



- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


@end

