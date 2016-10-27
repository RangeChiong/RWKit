//
//  UIApplication+OpenURL.m
//  Pods
//
//  Created by RangerChiong on 16/10/27.
//
//

//----------------------------------对照表----------------------------------
//           @{@"系统设置":@"prefs:root=INTERNET_TETHERING"},
//           @{@"WIFI设置":@"prefs:root=WIFI"},
//           @{@"蓝牙设置":@"prefs:root=Bluetooth"},
//           @{@"系统通知":@"prefs:root=NOTIFICATIONS_ID"},
//           @{@"通用设置":@"prefs:root=General"},
//           @{@"壁纸设置":@"prefs:root=Wallpaper"},
//           @{@"声音设置":@"prefs:root=Sounds"},
//           @{@"隐私设置":@"prefs:root=privacy"},
//           @{@"APP Store":@"prefs:root=STORE"},
//           @{@"Notes":@"prefs:root=NOTES"},
//           @{@"Safari":@"prefs:root=Safari"},
//           @{@"Music":@"prefs:root=MUSIC"},
//           @{@"Photo":@"prefs:root=Photos"}
//           @{@"关于本机":@"prefs:root=General&path=About"},
//           @{@"软件升级":@"prefs:root=General&path=SOFTWARE_UPDATE_LINK"},
//           @{@"日期时间":@"prefs:root=General&path=DATE_AND_TIME"},
//           @{@"Accessibility":@"prefs:root=General&path=ACCESSIBILITY"},
//           @{@"键盘设置":@"prefs:root=General&path=Keyboard"},
//           @{@"VPN":@"prefs:root=General&path=VPN"},
//           @{@"还原设置":@"prefs:root=General&path=Reset"},
//           @{@"显示设置":@"prefs:root=DISPLAY&BRIGHTNESS"},
//           @{@"应用通知":@"prefs:root=NOTIFICATIONS_ID&path=应用的boundleId"}

#import "UIApplication+OpenURL.h"
@import ObjectiveC;

static const void *App_GotoPath = &App_GotoPath;

@interface UIApplication ()

@property (nonatomic, strong) NSArray *pathArray;

@end

@implementation UIApplication (OpenURL)

- (void)gotoSystemSetting:(NSInteger)index {

    [self openURL:[NSURL URLWithString:[self pathArray][index]]];
}

- (void)gotoAppSetting {
    [self openURL:[NSURL URLWithString:[[self pathArray] lastObject]]];
}

- (NSArray *)pathArray {
    return objc_getAssociatedObject(self, App_GotoPath) ?: ({
        NSArray *pathArray = @[
                               @"prefs:root=INTERNET_TETHERING",
                               @"prefs:root=WIFI",
                               @"prefs:root=Bluetooth",
                               @"prefs:root=NOTIFICATIONS_ID",
                               @"prefs:root=General",
                               @"prefs:root=Wallpaper",
                               @"prefs:root=Sounds",
                               @"prefs:root=privacy",
                               @"prefs:root=STORE",
                               @"prefs:root=NOTES",
                               @"prefs:root=Safari",
                               @"prefs:root=MUSIC",
                               @"prefs:root=Photos",
                               @"prefs:root=General&path=About",
                               @"prefs:root=General&path=SOFTWARE_UPDATE_LINK",
                               @"prefs:root=General&path=DATE_AND_TIME",
                               @"prefs:root=General&path=ACCESSIBILITY",
                               @"prefs:root=General&path=Keyboard",
                               @"prefs:root=General&path=VPN",
                               @"prefs:root=General&path=Reset",
                               @"prefs:root=DISPLAY&BRIGHTNESS",
                               UIApplicationOpenSettingsURLString
                               // 8.0 之前NOTIFICATIONS_ID&path=应用的boundleId
                               // 8.0之后 UIApplicationOpenSettingsURLString
                               ];
        objc_setAssociatedObject(self, App_GotoPath, pathArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        pathArray;
    });
}

@end


