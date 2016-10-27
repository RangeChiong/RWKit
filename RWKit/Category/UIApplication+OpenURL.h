//
//  UIApplication+OpenURL.h
//  Pods
//
//  Created by RangerChiong on 16/10/27.
//
//

#import <UIKit/UIKit.h>

// app需要跳转系统设置界面，需要在URL type中添加一个prefs值
// 要跳转指定app的设置界面中，使用prefs:root=boundleId的方式，boundleId是app的boundleId。

@interface UIApplication (OpenURL)

- (void)gotoSystemSetting:(NSInteger)index;
- (void)gotoAppSetting;

@end
