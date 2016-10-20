//
//  UITableViewCell+Utils.m
//  findproperty
//
//  Created by Ranger on 16/8/20.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "UITableViewCell+Utils.h"

@implementation UITableViewCell (Utils)

+ (NSString *)rw_reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (instancetype)rw_loadWithStyleDefault {
    
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
}

+ (instancetype)rw_loadWithStyle:(UITableViewCellStyle)cellStyle {
    
    return [[self alloc] initWithStyle:cellStyle reuseIdentifier:NSStringFromClass(self)];
}

@end
