//
//  UITableViewCell+Utils.m
//  findproperty
//
//  Created by Ranger on 16/8/20.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "UITableViewCell+Utils.h"

@implementation UITableViewCell (Utils)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
