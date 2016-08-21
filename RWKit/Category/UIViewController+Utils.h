//
//  UIViewController+Utils.h
//  RWProgressHUD
//
//  Created by 常小哲 on 16/8/21.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utils)

- (__kindof UIViewController *)rw_push:(Class)controllerClass;

- (__kindof UIViewController *)rw_present:(Class)controllerClass;


@end

NS_ASSUME_NONNULL_END