//
//  UIViewController+Utils.m
//  RWProgressHUD
//
//  Created by 常小哲 on 16/8/21.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (__kindof UIViewController *)rw_push:(Class)controllerClass {
    UIViewController *nextVC = [self checkParam:controllerClass];
    [self.navigationController pushViewController:nextVC animated:YES];
    return nextVC;
}

- (__kindof UIViewController *)rw_present:(Class)controllerClass {
    UIViewController *nextVC = [self checkParam:controllerClass];
    [self presentViewController:nextVC animated:YES completion:nil];
    return nextVC;
}


#pragma mark-  private

- (__kindof UIViewController *)checkParam:(Class)controllerClass {
    NSParameterAssert([controllerClass isSubclassOfClass:[UIViewController class]]);
    return [[controllerClass alloc] init];
}

@end
