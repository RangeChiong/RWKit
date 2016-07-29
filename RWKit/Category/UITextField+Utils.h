//
//  UITextField+Utils.h
//  centanet
//
//  Created by Ranger on 16/7/28.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Utils)

/*!
 *  文本内容的最大长度
 */
- (void)rw_limitTextMaxLength:(NSInteger)len;

@end
