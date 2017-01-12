//
//  ZFProgressHUD.h
//  Test0103
//
//  Created by RangerChiong on 17/1/4.
//  Copyright © 2017年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFBackgroundView;

typedef NS_ENUM(NSInteger, ZFProgressHUDMode) {
    ZFProgressHUDMode_Indeterminate,
    ZFProgressHUDMode_OnlyText,
    ZFProgressHUDMode_CustomView
};

typedef NS_ENUM(NSInteger, ZFProgressHUDPosition) {
    ZFProgressHUDPosition_Center,
    ZFProgressHUDPosition_Bottom,
    ZFProgressHUDPosition_Top
};

typedef NS_ENUM(NSInteger, ZFProgressHUDAnimation) {
    ZFProgressHUDAnimation_Fade,
    ZFProgressHUDAnimation_Zoom,
    ZFProgressHUDAnimation_ZoomIn,
    ZFProgressHUDAnimation_ZoomOut,
//    ZFProgressHUDAnimation_FlyUp,   // only bottom position
    ZFProgressHUDAnimation_DropDown // only top position
};

typedef NS_ENUM(NSInteger, ZFProgressHUDBackgroundStyle) {
    ZFProgressHUDBackgroundStyle_ClearColor,
    ZFProgressHUDBackgroundStyle_BlurDark,
    ZFProgressHUDBackgroundStyle_BlurLight,
    ZFProgressHUDBackgroundStyle_BlurExtraLight
};

@interface ZFProgressHUD : UIView

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) ZFProgressHUDPosition position;
@property (nonatomic, assign) ZFProgressHUDMode mode;
@property (nonatomic, assign) ZFProgressHUDAnimation animationType;
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;

@property (nonatomic, strong) ZFBackgroundView *backgroundView;
@property (nonatomic, strong) ZFBackgroundView *bezelView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIColor *contentColor;


+ (instancetype)showOnView:(UIView *)view animated:(BOOL)animated;
+ (BOOL)hideOnView:(UIView *)view animated:(BOOL)animated;
+ (ZFProgressHUD *)HUDOnView:(UIView *)view;

+ (instancetype)setupOnView:(UIView *)view;

- (void)showAnimated:(BOOL)animated;
- (void)showAnimated:(BOOL)animated done:(dispatch_block_t)block;

- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated done:(dispatch_block_t)block;
- (void)hideAnimated:(BOOL)animated delay:(NSTimeInterval)ti done:(dispatch_block_t)block;

@end

#pragma mark-  ZFBackgroundView

@interface ZFBackgroundView : UIView

@property (nonatomic) ZFProgressHUDBackgroundStyle style;

@end
