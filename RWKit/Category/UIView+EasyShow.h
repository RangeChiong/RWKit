//
//  UIView+EasyShow.h
//  RPAntus
//
//  Created by Crz on 15/11/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyShow)

@property (nonatomic, assign, getter = rw_left, setter = setRw_Left:) CGFloat rw_x;
@property (nonatomic, assign, getter = rw_top, setter = setRw_Top:) CGFloat rw_y;
@property (nonatomic, assign, getter = rw_right, setter = setRw_Right:) CGFloat rw_maxX;
@property (nonatomic, assign, getter = rw_bottom, setter = setRw_Bottom:)CGFloat rw_maxY;
@property (nonatomic, assign) CGFloat rw_centerX;
@property (nonatomic, assign) CGFloat rw_centerY;
@property (nonatomic, assign) CGFloat rw_width;
@property (nonatomic, assign) CGFloat rw_height;
@property (nonatomic, assign) CGSize  rw_size;
@property (nonatomic, assign) CGPoint rw_origin;
@property (nonatomic, assign) CGFloat rw_cornerRadius;     //!< 圆角半径

- (void)rw_round;  //!< 圆形view

@end

//---------------------------------- XibHelper ----------------------------------
IB_DESIGNABLE
@interface UIView (XibHelper)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

@end

