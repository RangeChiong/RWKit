//
//  UITextField+Utils.m
//  centanet
//
//  Created by Ranger on 16/7/28.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "UITextField+Utils.h"
#import "NSObject+Notification.h"

@implementation UITextField (Utils)

- (void)rw_limitTextMaxLength:(NSInteger)len {
    [self rw_observeNotification:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        if (self.text.length > len) {
            [self deleteBackward];
        }
    }];
    self
}

@end
