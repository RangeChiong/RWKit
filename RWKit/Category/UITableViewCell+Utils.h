//
//  UITableViewCell+Utils.h
//  findproperty
//
//  Created by Ranger on 16/8/20.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Utils)

+ (NSString *)rw_reuseIdentifier;

+ (instancetype)rw_loadWithStyleDefault;
+ (instancetype)rw_loadWithStyle:(UITableViewCellStyle)cellStyle;

@end
